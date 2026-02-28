# Security Group para el ALB
resource "aws_security_group" "alb_sg_gonzalez" {
  name        = "alb-sg-${var.project_name}"
  description = "Permitir trafico HTTP entrante"
  vpc_id      = aws_vpc.vpc_gonzalez.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-alb-${var.project_name}" }
}

# Application Load Balancer
resource "aws_lb" "alb_gonzalez" {
  name               = "alb-${var.project_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg_gonzalez.id]
  subnets            = [aws_subnet.public_1_gonzalez.id, aws_subnet.public_2_gonzalez.id]

  tags = { Name = "alb-${var.project_name}" }
}

# Target Group
resource "aws_lb_target_group" "tg_gonzalez" {
  name        = "tg-${var.project_name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc_gonzalez.id
  target_type = "ip"

  health_check {
    path = "/"
  }

  tags = { Name = "tg-${var.project_name}" }
}

# Listener
resource "aws_lb_listener" "listener_gonzalez" {
  load_balancer_arn = aws_lb.alb_gonzalez.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_gonzalez.arn
  }
}
