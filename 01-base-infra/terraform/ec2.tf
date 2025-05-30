# SSHキーペアの生成
resource "tls_private_key" "ec2_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_ec2_key" {
  key_name   = "${var.name_prefix}-ec2-key"
  public_key = tls_private_key.ec2_ssh_key.public_key_openssh

  tags = {
    Name = "${var.name_prefix}-ec2-key"
  }
}

# 生成された秘密鍵をローカルファイルに保存 (取り扱いに十分注意！)
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ec2_ssh_key.private_key_pem
  filename        = "${path.module}/${var.name_prefix}-ec2-key.pem" # Terraform実行ディレクトリに保存
  file_permission = "0600"                                          # 所有者のみ読み取り可能
}

# プライベートサブネット (AZ A) 内のEC2インスタンス
resource "aws_instance" "app_a" {
  ## ★ AmazonLinux2023のAMIに置き換えてください
  ami                    = "<ami>"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_ec2_key.key_name
  # ★ Subnetに合わせてください
  private_ip             = "10.0.11.11"
  subnet_id              = aws_subnet.private_a.id                                  # network.tf で定義されたプライベートサブネット
  vpc_security_group_ids = [aws_security_group.appserver.id]                        # securitygroup.tf で定義されたSG
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_codedeploy_profile.name # iam.tf で定義されたプロファイル

  root_block_device {
    volume_size = 20 # 任意で調整
  }

  user_data = base64encode(
    templatefile(
      "user_data.sh", {
        host_name         = "${var.name_prefix}-app-server-a",
      }
    )
  )

  tags = merge(
    { Name = "${var.name_prefix}-app-server-a" },
    { category = "app" },
  )
}

# プライベートサブネット (AZ C) 内のEC2インスタンス
resource "aws_instance" "app_c" {
  ## ★ AmazonLinux2023のAMIに置き換えてください
  ami                    = "<ami>"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_ec2_key.key_name
  # ★ Subnetに合わせてください
  private_ip             = "10.0.111.11"
  subnet_id              = aws_subnet.private_c.id                                  # network.tf で定義されたプライベートサブネット
  vpc_security_group_ids = [aws_security_group.appserver.id]                        # securitygroup.tf で定義されたSG
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_codedeploy_profile.name # iam.tf で定義されたプロファイル

  root_block_device {
    volume_size = 20
  }

  user_data = base64encode(
    templatefile(
      "user_data.sh", {
        host_name         = "${var.name_prefix}-app-server-c",
      }
    )
  )

  tags = merge(
    { Name = "${var.name_prefix}-app-server-c" },
    { category = "app" },
  )
}

# 踏み台サーバー (Bastion Server) を AZ A のパブリックサブネットに作成
resource "aws_instance" "bastion_a" {
  ## ★ AmazonLinux2023のAMIに置き換えてください
  ami                         = "<ami>"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.generated_ec2_key.key_name
  # ★ Subnetに合わせてください
  private_ip                  = "10.0.1.201"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_codedeploy_profile.name
  associate_public_ip_address = true

  tags = {
    Name = "${var.name_prefix}-bastion-a"
  }
}
