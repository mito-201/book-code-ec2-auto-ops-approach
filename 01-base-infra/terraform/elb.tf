# Application Load Balancer 
resource "aws_lb" "main" {
  name                       = "${var.name_prefix}-alb"
  internal                   = false # インターネット向け
  load_balancer_type         = "application"
  enable_deletion_protection = false # サンプル用。本番ではtrueを推奨
  security_groups            = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]

  tags = { Name = "${var.name_prefix}-alb" }
}

# ターゲットグループ
resource "aws_lb_target_group" "app_http" {
  name        = "${var.name_prefix}-tg-app"
  port        = 80              # ターゲットインスタンスのポート
  protocol    = "HTTP"          # ALBからターゲットへのプロトコル
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/" # アプリケーションのヘルスチェックパス
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200" # 正常時のHTTPステータスコード
  }

  tags = { Name = "${var.name_prefix}-app-http-tg" }
}

# HTTPSリスナー
resource "aws_lb_listener" "https_frontend" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_http.arn
  }

  tags = {
    Name = "${var.name_prefix}-alb-listener-https"
  }
}

# EC2インスタンスをターゲットグループに登録
resource "aws_lb_target_group_attachment" "app_a" {
  target_group_arn = aws_lb_target_group.app_http.arn
  target_id        = aws_instance.app_a.id # EC2インスタンス "a" のリソース名.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_c" {
  target_group_arn = aws_lb_target_group.app_http.arn
  target_id        = aws_instance.app_c.id # EC2インスタンス "c" のリソース名.id
  port             = 80
}
