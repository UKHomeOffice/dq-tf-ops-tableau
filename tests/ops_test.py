# pylint: disable=missing-docstring, line-too-long, protected-access, E1101, C0202, E0602, W0109
import unittest
from runner import Runner


class TestE2E(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.snippet = """

            provider "aws" {
              region = "eu-west-2"
              skip_credentials_validation = true
              skip_get_ec2_platforms = true
            }

            module "tableau" {
              source = "./mymodule"

              providers = {
                aws = "aws"
              }

              vpc_subnet_cidr_block     = "10.2.1.0/24"
              az                        = "eu-west-2a"
              naming_suffix             = "ops-preprod-dq"
              tableau_dev_ip            = "1.2.3.4"
              opsvpc_id                 = "1234"
              tableau_subnet_cidr_block = "10.2.1.0/24"
              vpc_subnet_cidr_block     = "10.2.1.0/24"
              route_table_id            = "1234"
              ops_win_iam_role          = "1234"
              ops_config_bucket               = "s3-dq-ops-config"
              ops_nfs_backup_bucket           = "ops_nfs_backup_bucket-test"
              dq_pipeline_ops_readwrite_database_name_list = ["api_input"]
              dq_pipeline_ops_readonly_database_name_list  = ["api_input"]
              dq_pipeline_ops_readwrite_bucket_list        = ["s3-bucket-name"]
              dq_pipeline_ops_readonly_bucket_list         = ["s3-bucket-name"]
              dq_pipeline_ops_freight_readwrite_bucket_list        = ["s3-bucket-name"]
              dq_pipeline_ops_freight_readwrite_database_name_list = ["a-database-name"]
            }
        """
        self.result = Runner(self.snippet).result

    def test_root_destroy(self):
        self.assertEqual(self.result["destroy"], False)

    def test_subnet_cidr_block(self):
        self.assertEqual(self.result['tableau']["aws_subnet.tableau_subnet"]["cidr_block"], "10.2.1.0/24")

    def test_az(self):
        self.assertEqual(self.result['tableau']["aws_subnet.tableau_subnet"]["availability_zone"], "eu-west-2a")

    def test_name_tableau_sg(self):
        self.assertEqual(self.result['tableau']["aws_security_group.tableau"]["tags.Name"], "sg-tableau-ops-preprod-dq")

    def test_table_association(self):
        self.assertEqual(self.result['tableau']["aws_route_table_association.tableau_subnet"]["route_table_id"], "1234")

    def test_name_suffix_tableau_subnet(self):
        self.assertEqual(self.result['tableau']["aws_subnet.tableau_subnet"]["tags.Name"], "subnet-tableau-ops-preprod-dq")

    def test_name_tableau(self):
        self.assertEqual(self.result['tableau']["aws_instance.tableau"]["tags.Name"], "ec2-dev-tableau-ops-preprod-dq")


if __name__ == '__main__':
    unittest.main()
