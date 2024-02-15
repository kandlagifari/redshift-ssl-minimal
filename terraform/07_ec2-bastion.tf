data "aws_ami" "bastion_image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_allow_egress_sg"
  description = "Only allow egress traffic for bastion security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "bastion_allow_egress_sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_for_bastion" {
  security_group_id = aws_security_group.bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_iam_role" "bastion_role" {
  name = "bastion-iam-role"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Action" = "sts:AssumeRole",
        "Effect" = "Allow",
        "Sid"    = "",
        "Principal" = {
          "Service" = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

resource "aws_instance" "bastion_ami" {
  ami                    = data.aws_ami.bastion_image.id
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.bastion_instance_profile.name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = aws_subnet.public_1.id

  user_data = <<EOF
#!/bin/bash
echo "### INSTALL PSQL14 ###"
cd /home/ssm-user
sudo amazon-linux-extras install postgresql14 -y
echo "### INSTALL PIP ###"
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
source ~/.bash_profile
echo "### INSTALL MODULE ###"
pip3 install pgcli==2.1.1 --only-binary psycopg2
pip3 install psycopg2-binary
EOF

  tags = {
    "Name" = "bastion-ec2-redshift-ssl"
  }
}
