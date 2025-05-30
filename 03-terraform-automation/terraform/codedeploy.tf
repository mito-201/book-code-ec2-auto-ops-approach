resource "aws_codedeploy_app" "main" {
  compute_platform = "Server"
  name             = var.name_prefix
}

resource "aws_codedeploy_deployment_group" "main" {
  app_name               = aws_codedeploy_app.main.name
  deployment_group_name  = "${var.name_prefix}-dg-app"
  service_role_arn       = aws_iam_role.codedeploy_service_role.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime" # デプロイの待機台数を1台とする。グループに2台以上必要。

  ec2_tag_set {
    ec2_tag_filter {
      key   = "category"
      type  = "KEY_AND_VALUE"
      value = "app"
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = "${var.name_prefix}-tg-app"
    }
  }
}
