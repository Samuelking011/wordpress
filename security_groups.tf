# Security_groups.tf

#ALB security group allow select traffic to EC2 instance
resource "aws_security_group" "ec2_elb" {
    name            = "${var.app_name}-elb-sg"
    description     = "SG for ELB to access the EC2"
    vpc_id          = aws_vpc.ec2_vpc.id

     ingress {
        description         = "Allow SSH access from anywhere"
        from_port           = 22
        to_port             = 22
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
        ipv6_cidr_blocks    = ["::/0"]
    }

    ingress {
        description         = "Allow HTTP access from anywhere"
        from_port           = 80
        to_port             = 80
        protocol            = "tcp"
        cidr_blocks         = ["0.0.0.0/0"]
        ipv6_cidr_blocks    = ["::/0"]
    }

    egress {
        from_port           = 0
        to_port             = 0
        protocol            = "-1"
        cidr_blocks         = ["0.0.0.0/0"]
        ipv6_cidr_blocks    = ["::/0"]
    }

    tags = {
        Name        = "${var.app_name}-elb-sg"
        Environment = "${var.app_env}"
    }
}

#Allow HTTP traffic(port 80) from the internet to EC2 tasks
resource "aws_security_group" "ec2_tasks" {
    name                = "${var.app_name}-ec2-tasks-sg"
    description         = "SG for EC2 tasks to allow access only from the ELB"
    vpc_id              = aws_vpc.ec2_vpc.id

    ingress {
        description     = "Allow application access form ${var.app_name}-elb-sg"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.ec2_elb.id]
    }


    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name        = "${var.app_name}-ec2-tasks-sg"
        Environment = "${var.app_env}"
    }
}