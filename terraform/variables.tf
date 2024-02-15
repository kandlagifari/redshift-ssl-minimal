variable "aws_profile" {
  description = "AWS Profile for Terraform"
  type        = string
}

variable "redshift_master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "redshift_master_password" {
  description = "Password for the master DB user"
  type        = string
}
