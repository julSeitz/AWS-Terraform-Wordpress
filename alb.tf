# Creating Application Load Balancer and Listener

# Creating Application Load Balancer
resource "aws_lb" "wordpress" {
    name = "wordpress-app-lb"
    internal = false
    load_balancer_type = "application"
    subnets = [aws_subnet.publicSubnetA.id,aws_subnet.publicSubnetB.id]
    security_groups = [aws_security_group.alb_sg.id]
}

# Creating Listener for Application Load Balancer
resource "aws_lb_listener" "wordpress" {
    load_balancer_arn = aws_lb.wordpress.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      forward {
        target_group {
          arn = aws_lb_target_group.test_group_one.arn
          weight = 50
        }

        target_group {
          arn = aws_lb_target_group.test_group_two.arn
          weight = 50
        }
      }
    }
}