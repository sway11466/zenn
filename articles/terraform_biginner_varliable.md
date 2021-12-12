---
title: "変数の使い方 - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: false
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
記事で説明すること
作業の流れ
Terraformを使用していると

# ゴール
ファイル名と中身を変数で指定してファイルを作成する。

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# 変数の種類と特徴
Trraformの変数には2つの種類があります。
- ローカル変数（Loacal Values）
    - 特徴
        - 式をかける
        - 外部から指定できない
        - デフォルト値は定義できない
- 入力変数（Input Variables）
    - 特徴
        - 値のみ指定できる
        - 外部から指定できる
        - デフォルト値の定義が可能
    - 値の指定方法
        - apply実行時に対話的に入力
        - コマンドラインから-varオプションや-ver-fileオプションで指定
        - terraform.tfvarsファイルで指定
        - 環境変数(TF_VAR_xxxなど)で指定

# 変数の作成方法とコードでの使用方法
- ローカル変数（Loacal Values）
    - 定義方法
        locals {
            key = value
        }
    - コードでの使用方法
        local.key
- 入力変数（Input Variables）
    - 定義方法
        variable key {
        }
    - コードでの使用方法
      var.name
    - 外部からの値の指定方法

# ローカル変数を使用したファイル生成コードを作る

1. terraformコード作成する
    ```hcl:helloworld_local.tf
    locals {
      content  = "use local variables."
      filename = "hello_local.txt"
    }
    resource "local_file" "helloworld" {
      content  = local.content
      filename = local.filename
    }
    ```

1. plan
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_00.jpg)

1. apply

# 入力変数を使用したファイル生成コードを作る

1. terraformコード作成する
    ```hcl:helloworld_input.tf
    ```

1. plan

1. apply


# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_varliable)

# 参考ページ
- Terraformオフィシャルのlocal変数の説明ページ
    @[card](https://www.terraform.io/docs/language/values/locals.html)
- Terraformオフィシャルのinput変数の説明ページ
    @[card](https://www.terraform.io/docs/language/values/variables.html)

# 次はこれをやろう
- [モジュールの使い方](https://zenn.dev/sway/articles/terraform_biginner_modules)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
