terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 最新のバージョンを確認してください
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0" # 最新のバージョンを確認してください
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4" # 最新のバージョンを確認してください
    }
  }
}

provider "aws" {
  region = var.region
  # AWS認証情報は環境変数や~/.aws/credentialsから読み込まれる想定
}
