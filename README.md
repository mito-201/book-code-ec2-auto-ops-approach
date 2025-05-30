# 『EC2運用自動化へのアプローチ』サンプルコード

本書『EC2運用自動化へのアプローチ ～AnsibleとTerraformで作る自動化の仕組み～』（サークル: AutoOps屋, 著者: mito）で解説しているサンプルコードを格納するリポジトリです。

本書は、AWS EC2インスタンスの運用を自動化するための様々なアプローチ（Terraformによるインフラ構築、AnsibleによるSSH/SSM経由での構成管理、CodePipeline/CodeDeployによるデプロイ自動化など）を実践的に学ぶことを目的としています。このリポジトリのコードは、書籍の解説と合わせてご利用いただくことで、より理解を深め、実際に手を動かして技術を習得できるよう構成されています。

## 📚 本書について

* **イベント:** 技術書典18 (日付: 2025年5月31日)
* **スペース:** か03
* **オンライン頒布:** [https://techbookfest.org/product/5KztHE3TNKy3cjcM9ahjzM]
* **X (旧Twitter):** @mito0358 (著者)

## 🎯 リポジトリの目的

このリポジトリは、書籍『EC2運用自動化へのアプローチ』の各章で紹介されているTerraformコード、Ansible Playbook、各種スクリプト、設定ファイルなどを提供します。読者の皆様が書籍の内容を追体験し、ご自身の環境で自動化技術を試すための一助となることを目指しています。

## ⚙️ 前提条件

このリポジトリのコードを利用するには、以下の環境やツールが準備されていることを前提とします。

* AWSアカウントおよび基本的なAWSの知識 (VPC, EC2, S3, IAMなど)
* Terraform (本書執筆時点のバージョン: v1.11.4)
* Ansible (本書執筆時点のバージョン: ansible-core 2.18.5, ansible (community package) 11.2.0 )
* AWS CLI (最新版推奨) が設定済みであること (認証情報、デフォルトリージョン)
* Gitクライアント
* (必要に応じて) `tfenv`, Python仮想環境などの関連ツール

## 📂 ディレクトリ構成

コードは、書籍の章に対応するディレクトリに格納されています。

* `01-base-infra/terraform/`: 第1章 サンプルAWS環境構築用Terraformコード
* `02-ansible-automation/ansible/`: 第2章 Ansible Playbook、インベントリファイル、設定ファイル
* `03-codepipeline-automation/`: 第3章 CodePipeline/CodeDeploy関連Terraformコード、`appspec.yml`、運用スクリプト

## 🚀 使い方

1.  本書の解説を読み進めながら、対応するディレクトリのコードを参照してください。
2.  Terraformのコードを実行する場合:
    ```bash
    cd <章のディレクトリ>/terraform
    terraform init
    # variables.tf 内の変数や、*.tfvars ファイルで値を設定
    terraform plan
    terraform apply
    ```
3.  AnsibleのPlaybookを実行する場合:
    ```bash
    cd <章のディレクトリ>/ansible
    # inventory/ ディレクトリ内のインベントリファイルを適宜編集
    ansible-playbook -i inventory/<使用するインベントリファイル> <Playbookファイル名>.yml
    ```
4.  **【重要】** コード内のプレースホルダー（例: `<YOUR_...>`, `arn:aws:acm:.../YOUR-CERT-ID`, IPアドレス、インスタンスIDなど）は、ご自身の環境に合わせて実際の値に置き換えてください。詳細は書籍の各章で説明しています。

## 正誤表

以下に、第1版の[正誤表](正誤表.md)を載せています。

## 📄 ライセンス

このリポジトリ内のサンプルコードは、[Apache License 2.0](LICENSE) の下で公開しています。

## 💬 フィードバック・コントリビューション

本書の内容やサンプルコードに関する誤り、改善提案、ご質問などがありましたら、お気軽にこのリポジトリのIssuesや巻末の連絡先までご報告ください。

---

このリポジトリが、皆さんのEC2運用自動化の一助となれば幸いです。

**AutoOps屋 / mito**