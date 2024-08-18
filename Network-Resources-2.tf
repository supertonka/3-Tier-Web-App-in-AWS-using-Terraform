# Create the Bastion Host EC2 instance
resource "aws_instance" "bastion_host" {
  ami                         = "ami-0427090fd1714168b"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet1_AZ1.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.bastion_host_sg.id]
  key_name                    = aws_key_pair.bastion_host_key.key_name

  tags = {
    Name = "Bastion-Host"
  }
}

resource "aws_instance" "web_ec2_1"{ 
    ami = "ami-0427090fd1714168b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet1_AZ1.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.web_tier_sg.id]  
    key_name                    = aws_key_pair.web_tier_ec2_1_key.key_name
    tags = {
    Name = "Web-Tier-EC2-AZ1"
    }

}

resource "aws_instance" "web_ec2_2"{
    ami = "ami-0427090fd1714168b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet1_AZ2.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.web_tier_sg.id]

    tags = {
    Name = "Web-Tier-EC2-AZ2"
    }
}

resource "aws_instance" "app_ec2_1"{
    ami = "ami-0427090fd1714168b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet1_AZ1.id
    security_groups = [aws_security_group.app_tier_sg.id]
    key_name                    = aws_key_pair.app_tier_ec2_1_key.key_name
    tags = {
    Name = "App-Tier-EC2-AZ1"
    }
}

resource "aws_instance" "app_ec2_2"{
    ami = "ami-0427090fd1714168b"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet1_AZ2.id
    security_groups = [aws_security_group.app_tier_sg.id]

    tags = {
    Name = "App-Tier-EC2-AZ2"
    }
}

resource "aws_db_subnet_group" "db"{
    name = "rds_db_subnet_group_1"
    subnet_ids = [aws_subnet.private_subnet2_AZ1.id, aws_subnet.private_subnet2_AZ2.id]
}

resource "aws_db_instance" "rds_db"{
    identifier = "mydbinstance"
    allocated_storage = 20
    engine = "mysql"
    engine_version = "8.0.32"
    instance_class = "db.t3.micro"
    username = "superds1"
    password = "defaultpassword"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot = true
    db_subnet_group_name = aws_db_subnet_group.db.name
    vpc_security_group_ids = [aws_security_group.db_tier_sg.id]
    multi_az = false
    publicly_accessible = false
    storage_type = "gp2"
    apply_immediately = true
}


