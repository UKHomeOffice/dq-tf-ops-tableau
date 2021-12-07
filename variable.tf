variable "account_id" {
  type = map(string)
  default = {
    "test"    = "797728447925"
    "notprod" = "483846886818"
    "prod"    = "337779336338"
  }
}

variable "ops_config_bucket" {
}

variable "key_name" {
  description = "Default SSH key name for EC2 instances"
  default     = "test_instance"
}

variable "tableau_dev_ip" {
  description = "Tableau Development IP address"
  default     = "10.0.0.1"
}

# variable "tableau_deployment_ip" {
#   description = "Tableau Deployment IP address"
#   default     = "10.0.0.2"
# }

variable "opsvpc_id" {
  description = "OPS VPC ID"
}

variable "tableau_subnet_cidr_block" {
  description = "Tableau Dev CIDR block"
}

variable "vpc_subnet_cidr_block" {
  description = "VPC CIDR block"
}

variable "naming_suffix" {
  description = "Default naming suffix"
}

variable "az" {
  description = "Availability zone"
}

variable "route_table_id" {
  description = "Route table ID"
}

variable "dq_pipeline_ops_readwrite_bucket_list" {
  description = "RW Bucket list from dq-tf-apps"
  type        = list(string)
}

variable "dq_pipeline_ops_readonly_bucket_list" {
  description = "RO Bucket list from dq-tf-apps"
  type        = list(string)
}

variable "apps_aws_bucket_key" {
  description = "Apps KMS key"
}

variable "namespace" {
  description = "namespace"
}

variable "dq_pipeline_ops_readwrite_database_name_list" {
  description = "RW Database list from dq-tf-apps"
  type        = list(string)
}

variable "dq_pipeline_ops_readonly_database_name_list" {
  description = "RO Database list from dq-tf-apps"
  type        = list(string)
}

variable "tableau_deployment_ip" {
  description = "IP address of EC2 instance"
  type        = list(string)
  default     = ["10.0.0.2", "10.0.0.3", "10.0.0.4", "10.0.0.5"]
}
