"""Offline regression tests: the scraper must not expose deploy credentials.

Run with: python3 -m unittest discover -s tests -v
"""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
import uuid


SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "scrape-site.sh"

# Exported shell functions take precedence over PATH, which the script modifies.
# Every curl invocation is intercepted; tests never contact a network service.
MOCK_CURL = r'''
curl() {
  local output=""
  while [ "$#" -gt 0 ]; do
    if [ "$1" = "-o" ]; then
      output="$2"
      shift 2
    else
      shift
    fi
  done
  if [ -n "$output" ]; then
    printf '<html><body>Offline fixture</body></html>' > "$output"
  else
    printf '{"data":{"markdown":"Offline fixture"}}'
  fi
}
export -f curl
exec bash "$@"
'''


class ScrapeSiteSecurityTests(unittest.TestCase):
    def run_scraper(self, token_source, use_firecrawl=False, trace=False):
        marker = "TEST_ONLY_DEPLOY_CREDENTIAL_DO_NOT_PRINT"
        domain = "scrape-security-" + uuid.uuid4().hex + ".invalid"
        output_dir = Path("/tmp/website-remake-targets") / domain.replace(".", "_")
        self.addCleanup(shutil.rmtree, output_dir, True)
        with tempfile.TemporaryDirectory() as home:
            secrets = Path(home) / ".openclaw/workspace/.secrets"
            secrets.mkdir(parents=True)
            env = os.environ.copy()
            # Do not inherit real credentials or shell initialization hooks.
            for name in (
                "NETLIFY_TOKEN", "NETLIFY_AUTH_TOKEN", "FIRECRAWL_API_KEY",
                "BASH_ENV", "ENV", "SHELLOPTS", "BASHOPTS",
            ):
                env.pop(name, None)
            env["HOME"] = home
            if use_firecrawl:
                env["FIRECRAWL_API_KEY"] = "TEST_ONLY_FIRECRAWL_FIXTURE"
            if token_source == "environment":
                env["NETLIFY_TOKEN"] = marker
                env["NETLIFY_AUTH_TOKEN"] = marker
            elif token_source == "text_file":
                (secrets / "netlify-token.txt").write_text(marker + "\n")
            elif token_source == "env_file":
                # Also detect sourcing the file even if its token is not printed.
                (secrets / "netlify.env").write_text(
                    f'NETLIFY_TOKEN="{marker}"\n'
                    'touch "$HOME/netlify-env-was-sourced"\n'
                )
            args = ["bash", "-c", MOCK_CURL, "offline-test"]
            if trace:
                args.append("-x")
            args += [str(SCRIPT), "https://" + domain]
            result = subprocess.run(args, env=env, capture_output=True, text=True, timeout=15)
            self.assertEqual(result.returncode, 0, "offline scrape should succeed")
            self.assertNotIn(marker, result.stdout + result.stderr)
            self.assertFalse((Path(home) / "netlify-env-was-sourced").exists())
            self.assertIn("Offline fixture", result.stdout)
            self.assertIn("netlify deploy --dir=./dist --prod", result.stdout)
            self.assertNotIn("--auth=", result.stdout)
            self.assertIn("NETLIFY_AUTH_TOKEN", result.stdout)

    def test_fallback_never_loads_or_prints_deployment_credentials(self):
        for source in ("environment", "text_file", "env_file", "none"):
            with self.subTest(source=source):
                self.run_scraper(source)

    def test_firecrawl_never_loads_or_prints_deployment_credentials(self):
        for source in ("environment", "text_file", "env_file", "none"):
            with self.subTest(source=source):
                self.run_scraper(source, use_firecrawl=True)

    def test_shell_trace_does_not_expose_deployment_credentials(self):
        for source in ("environment", "text_file", "env_file"):
            with self.subTest(source=source):
                self.run_scraper(source, trace=True)


if __name__ == "__main__":
    unittest.main()
