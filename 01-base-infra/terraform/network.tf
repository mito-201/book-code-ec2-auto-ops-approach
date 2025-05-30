# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16" # ★ 各自の値に置き換えてください
  tags                 = { Name = "${var.name_prefix}-vpc" }
  enable_dns_hostnames = true
}

# インターネットゲートウェイ
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name_prefix}-igw" }
}

# ルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = { Name = "${var.name_prefix}-rtb-public" }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
  tags = { Name = "${var.name_prefix}-rtb-private-a" }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_c.id
  }
  tags = { Name = "${var.name_prefix}-rtb-private-c" }
}

# パブリックサブネットの作成
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"  # ★ VPCに合わせてください
  availability_zone = "${var.region}a"
  tags              = { Name = "${var.name_prefix}-subnet-public-a" }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24" # ★ VPCに合わせてください
  availability_zone = "${var.region}c"
  tags              = { Name = "${var.name_prefix}-subnet-public-c" }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"  # ★ VPCに合わせてください
  availability_zone = "${var.region}a"
  tags              = { Name = "${var.name_prefix}-subnet-private-a" }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.111.0/24"  # ★ VPCに合わせてください
  availability_zone = "${var.region}c"
  tags              = { Name = "${var.name_prefix}-subnet-private-c" }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.private_a.id, aws_route_table.private_c.id]
  tags            = { Name = "${var.name_prefix}-vpcendpoint" }
}

# NATゲートウェイ用のElastic IP
resource "aws_eip" "nat_a" {
  domain = "vpc"
  tags   = { Name = "${var.name_prefix}-eip-nat-a" }
}

resource "aws_eip" "nat_c" {
  domain = "vpc"
  tags   = { Name = "${var.name_prefix}-eip-nat-c" }
}

# NATゲートウェイ
resource "aws_nat_gateway" "nat_a" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id
  tags          = { Name = "${var.name_prefix}-natgw-a" }
}

resource "aws_nat_gateway" "nat_c" {
  depends_on = [aws_internet_gateway.main]

  allocation_id = aws_eip.nat_c.id
  subnet_id     = aws_subnet.public_c.id
  tags          = { Name = "${var.name_prefix}-natgw-c" }
}

# ルートテーブルとサブネットの関連付け
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private_c.id
}
