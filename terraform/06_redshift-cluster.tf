# resource "aws_security_group" "redshift_ssl_sg" {
#   name        = "redshift_ssl_sg"
#   description = "Allow bastion for redshift ssl security group"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "redshift_ssl_sg"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_bastion_sg" {
#   security_group_id            = aws_security_group.redshift_ssl_sg.id
#   referenced_security_group_id = aws_security_group.bastion_sg.id
#   ip_protocol                  = "tcp"
#   from_port                    = 5439
#   to_port                      = 5439
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_sg_itself" {
#   security_group_id            = aws_security_group.redshift_ssl_sg.id
#   referenced_security_group_id = aws_security_group.redshift_ssl_sg.id
#   ip_protocol                  = "-1"
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_redshift" {
#   security_group_id = aws_security_group.redshift_ssl_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
# }


# module "redshift-ssl-cluster" {
#   source  = "terraform-aws-modules/redshift/aws"
#   version = "5.2.0"

#   cluster_identifier    = "redshift-ssl-cluster"
#   allow_version_upgrade = true
#   node_type             = "dc2.large"
#   number_of_nodes       = 1

#   database_name          = "coffeedb"
#   create_random_password = false
#   master_username        = var.redshift_master_username # Do better!
#   master_password        = var.redshift_master_password # Do better!
#   encrypted              = false

#   enhanced_vpc_routing   = false
#   vpc_security_group_ids = [aws_security_group.redshift_ssl_sg.id]
#   subnet_ids = [
#     # aws_subnet.public_1.id,
#     # aws_subnet.public_2.id,
#     aws_subnet.private_1.id,
#     aws_subnet.private_2.id
#   ]

#   # Parameter group
#   parameter_group_name        = "redshift-ssl-parameter-group"
#   parameter_group_description = "Custom Parameter Group for Redshift SSL Cluster"
#   parameter_group_parameters = {
#     require_ssl = {
#       name  = "require_ssl"
#       value = true
#     }
#   }
#   parameter_group_tags = {
#     Additional = "SSLParameterGroup"
#   }

#   # Subnet group
#   subnet_group_name        = "redshift-ssl-subnet-group"
#   subnet_group_description = "Custom Subnet Group for Redshift SSL Cluster"
#   subnet_group_tags = {
#     Additional = "SSLSubnetGroup"
#   }

#   tags = {
#     Name = "redshift-ssl-cluster"
#   }
# }
