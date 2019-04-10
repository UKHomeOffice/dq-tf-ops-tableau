variable "key_name" {
  description = "Default SSH key name for EC2 instances"
  default     = "test_instance"
}

variable "tableau_dev_ip" {
  description = "Tableau Development IP address"
  default = "10.0.0.1"
}
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
