# Creating Application Load Balancer and Listener

# Creating Application Load Balancer
resource "aws_lb" "wordpress" {
  count              = var.set_infrastructure_to_savings_mode ? 0 : 1
  name               = "wordpress-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

# Creating Listener for Application Load Balancer
resource "aws_lb_listener" "wordpress_listener" {
  count             = var.set_infrastructure_to_savings_mode ? 0 : 1
  load_balancer_arn = aws_lb.wordpress[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.autoscaling_tg.arn
  }
}

# Creating ALB Target Group for Autoscaling Group
resource "aws_lb_target_group" "autoscaling_tg" {
  name     = "autoscaling-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.wordpress_vpc.id

  health_check {
    protocol            = "HTTP"
    port                = 80
    matcher             = "200-399"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Autoscaling Target Group"
  }
}
