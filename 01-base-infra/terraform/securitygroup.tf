# ALB用セキュリティグループ
resource "aws_security_group" "alb" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB for web application"
  tags        = { Name = "${var.name_prefix}-sg-alb" }
}

resource "aws_security_group_rule" "alb_ingress_https" {
  description       = "Allow HTTPS inbound from anywhere"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_egress_all" {
  description       = "Allow all outbound traffic from ALB"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

# Bastion用セキュリティグループ
resource "aws_security_group" "bastion" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.name_prefix}-bastion-sg"
  description = "Security group for bastion host"
  tags        = { Name = "${var.name_prefix}-sg-bastion" }
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  description       = "Allow SSH inbound from my IP address"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] # 自身のIPアドレスを指定するなど、限定してください
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_egress_all" {
  description       = "Allow all outbound traffic from bastion"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] # 必要に応じて絞り込む (例: VPC内へのSSHのみなど)
  security_group_id = aws_security_group.bastion.id
}

# AppServer用セキュリティグループ
resource "aws_security_group" "appserver" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.name_prefix}-appserver-sg"
  description = "Security group for application servers"
  tags        = { Name = "${var.name_prefix}-sg-appserver" }
}

resource "aws_security_group_rule" "appserver_ingress_ssh_from_bastion" {
  description              = "Allow SSH inbound from bastion SG"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
  security_group_id        = aws_security_group.appserver.id
}

resource "aws_security_group_rule" "appserver_ingress_http_from_alb" {
  description              = "Allow HTTP (port 80) inbound from ALB SG"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.appserver.id
}

resource "aws_security_group_rule" "appserver_egress_all" {
  description       = "Allow all outbound traffic from appserver"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.appserver.id
}
