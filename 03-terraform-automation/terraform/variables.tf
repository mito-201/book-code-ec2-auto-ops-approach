variable "region" {
  type    = string
  default = "<resion>" # 任意のリージョンを指定
}

variable "name_prefix" {
  description = "リソース名に使用するプレフィックス"
  type        = string
  default     = "<name_prefix>" # ★ 各自の値に置き換えてください
}

variable "certificate_arn" {
  type    = string
  default = "<certificate>" # ★ 各自の証明書ARNに置き換えてください
}
