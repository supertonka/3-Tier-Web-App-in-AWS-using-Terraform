#creating The Web-Tier ALB
resource "aws_lb" "web_tier_alb"{
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.web_tier_alb_sg.id]
    subnets = [aws_subnet.public_subnet1_AZ1.id, aws_subnet.public_subnet1_AZ2.id]
    enable_deletion_protection = false
    enable_http2 = true
}

#creating The Web-Tier ALB Target Group
resource "aws_lb_target_group" "web_tier_alb_target_group"{
    name = "web-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
}

#Creating The Web-Tier ALB Listener
resource "aws_lb_listener" "web_tier_alb_listener"{
    load_balancer_arn = aws_lb.web_tier_alb.arn
    port = 80
    protocol = "HTTP"

    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.web_tier_alb_target_group.arn
    }
}

resource "aws_lb_target_group_attachment" "web_tier_target_group_attachment_1"{
    target_group_arn = aws_lb_target_group.web_tier_alb_target_group.arn
    target_id = aws_instance.web_ec2_1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "web_tier_target_group_attachment_"{
    target_group_arn = aws_lb_target_group.web_tier_alb_target_group.arn
    target_id = aws_instance.web_ec2_2.id
    port = 80
}

resource "aws_lb" "app_tier_alb"{
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.app_tier_alb_sg.id]
    subnets = [aws_subnet.private_subnet1_AZ1.id,aws_subnet.private_subnet1_AZ2.id]
}

resource "aws_lb_target_group" "app_tier_alb_target_group"{
    name = "app-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "app_tier_alb_listener"{
    load_balancer_arn = aws_lb.app_tier_alb.arn
    port = 80
    protocol = "HTTP"

    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.app_tier_alb_target_group.arn
    }
}

resource "aws_lb_target_group_attachment" "app_tier_target_group_attachment_1"{
    target_group_arn = aws_lb_target_group.app_tier_alb_target_group.arn
    target_id = aws_instance.app_ec2_1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "app_tier_target_group_attachment_2"{
    target_group_arn = aws_lb_target_group.app_tier_alb_target_group.arn
    target_id = aws_instance.app_ec2_2.id
    port = 80
}