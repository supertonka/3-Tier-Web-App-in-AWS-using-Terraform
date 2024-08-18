resource "aws_security_group" "web_tier_sg"{
    name = "web_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "app_tier_sg"{
    name = "app_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.web_tier_sg.id] #allows incomming traffic from web tier SG only
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "db_tier_sg"{
    name = "db_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.app_tier_sg.id]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "bastion_host_sg"{
    name = "bastion_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["41.116.0.116/32"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "web_tier_alb_sg"{
    name = "web_alb_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "app_tier_alb_sg"{
    name = "app_alb_sg"
    vpc_id = aws_vpc.main.id

    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.web_tier_alb_sg.id]
    }

     # Allow inbound traffic from web-tier security group on health check port (if different)
    ingress{
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.web_tier_alb_sg.id]
  }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



