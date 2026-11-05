import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class SecurityDefaultsTest(unittest.TestCase):
    def test_default_node_pool_uses_workload_identity(self):
        source = (ROOT / "modules/cluster/main.tf").read_text()
        pool = source.split(
            'resource "google_container_node_pool" "default" {', 1
        )[1].split("\nresource ", 1)[0]
        self.assertRegex(
            pool,
            r'node_config\s*\{[^{}]*workload_metadata_config\s*\{'
            r'\s*mode\s*=\s*"GKE_METADATA"\s*\}',
        )

    def test_database_audits_ddl_and_roles_and_preserves_existing_flags(self):
        source = (ROOT / "modules/database/main.tf").read_text()
        instance = source.split(
            'resource "google_sql_database_instance" "default" {', 1
        )[1].split("\nresource ", 1)[0]
        flags = dict(re.findall(
            r'database_flags\s*\{\s*name\s*=\s*"([^"]+)"'
            r'\s*value\s*=\s*"([^"]+)"\s*\}',
            instance,
        ))
        for name, value in {
            "cloudsql.iam_authentication": "on",
            "max_connections": "1000",
            "cloudsql.enable_pgaudit": "on",
            "pgaudit.log": "ddl,role",
        }.items():
            with self.subTest(flag=name):
                self.assertEqual(flags.get(name), value)


if __name__ == "__main__":
    unittest.main()
