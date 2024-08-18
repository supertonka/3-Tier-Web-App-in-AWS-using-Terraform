# Create an SSH key pair
resource "tls_private_key" "bastion_host_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion_host_key" {
  key_name   = "bastion_host_key"
  public_key = tls_private_key.bastion_host_key.public_key_openssh
}

# Save the private key to a file
resource "local_file" "private_key" {
  content  = tls_private_key.bastion_host_key.private_key_pem
  filename = "${path.module}/bastion_host_private_key.pem"
}

# Create an SSH key pair
resource "tls_private_key" "web_tier_ec2_1_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "web_tier_ec2_1_key" {
  key_name   = "web_tier_ec2_1_key"
  public_key = tls_private_key.web_tier_ec2_1_key.public_key_openssh
}

# Save the private key to a file
resource "local_file" "private_key_web" {
  content  = tls_private_key.web_tier_ec2_1_key.private_key_pem
  filename = "${path.module}/web_tier_ec2_1_privatekey.pem"
}

# Create an SSH key pair
resource "tls_private_key" "app_tier_ec2_1_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "app_tier_ec2_1_key" {
  key_name   = "app_tier_ec2_1_key"
  public_key = tls_private_key.app_tier_ec2_1_key.public_key_openssh
}

# Save the private key to a file
resource "local_file" "private_key_app" {
  content  = tls_private_key.app_tier_ec2_1_key.private_key_pem
  filename = "${path.module}/app_tier_ec2_1_privatekey.pem"
}