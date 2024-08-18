resource "aws_launch_template" "web_tier_lt"{
    image_id = "ami-0427090fd1714168b"
    instance_type = "t2.micro"

    network_interfaces{
        associate_public_ip_address = true
        security_groups = [aws_security_group.web_tier_sg.id]
    }

    tag_specifications{
        resource_type = "instance"
        tags = {
            Name = "web-tier-instance"
        }

    }
}

resource "aws_launch_template" "app_tier_lt"{
    image_id = "ami-0427090fd1714168b"
    instance_type = "t2.micro"

    network_interfaces{
        associate_public_ip_address = false
        security_groups = [aws_security_group.app_tier_sg.id]
    }

    tag_specifications{
        resource_type = "instance"
        tags = {
            Name = "app-tier-instance"
        }
        
    }
}

resource "aws_autoscaling_group" "web_tier_asg"{
    desired_capacity = 2
    max_size = 3
    min_size = 1
    vpc_zone_identifier = [aws_subnet.public_subnet1_AZ1.id, aws_subnet.public_subnet1_AZ2.id]
    
    launch_template{
        id = aws_launch_template.web_tier_lt.id
        version = "$Latest"
    }

    target_group_arns = [aws_lb_target_group.web_tier_alb_target_group.arn]
    tag { 
            key = "Name"
            value = "web-tier-asg"
            propagate_at_launch = true        
    }
}

resource "aws_autoscaling_group" "app_tier_asg"{
    desired_capacity = 2
    max_size = 3
    min_size = 1
    vpc_zone_identifier = [aws_subnet.private_subnet1_AZ1.id,aws_subnet.private_subnet1_AZ2.id]

    launch_template{
        id = aws_launch_template.app_tier_lt.id
        version = "$Latest"
    }

    target_group_arns = [aws_lb_target_group.app_tier_alb_target_group.arn]
    tag {
        
            key = "Name"
            value = "app-tier-asg"
            propagate_at_launch = true
        
    }
}