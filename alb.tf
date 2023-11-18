# alb.tf

#ALB utilizing the security group
resource "aws_alb" "ec2_alb" {
    name                = "${var.app_name}-application-alb"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.ec2_elb.id]
    subnets             = aws_subnet.ec2_public.*.id

    tags = {
        Name            = "${var.app_name}-application-elb"
        Environment     = "${var.app_env}"
    }
}

#new target group for the ALB HTTP traffic along with a health check to determine if the container is working as expected.
resource "aws_lb_target_group" "ec2_alb_tg" {
    name                = "${var.app_name}-alb-tg"
    port                = 80
    protocol            = "HTTP"
    vpc_id              = aws_vpc.ec2_vpc.id
    target_type         = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "30"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "3"
        path                = "/health_check"
        unhealthy_threshold = "2"
    }

    tags = {
        Name                = "${var.app_name}-alb-tg"
        Environment         = "${var.app_env}"
    }
}

#Register ALB HTTP listener.
resource "aws_lb_listener" "ec2_alb_http_listener" {
    load_balancer_arn   = aws_alb.ec2_alb.id
    port                = "80"
    protocol            = "HTTP"

    default_action {
      type              = "forward"
      target_group_arn  = aws_lb_target_group.ec2_alb_tg.id
    }

     tags = {
    Name        = "${var.app_name}-http-listener"
    Environment = "${var.app_env}"
  }
}