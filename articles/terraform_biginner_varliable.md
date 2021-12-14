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
Trraformには2種類の変数があります。
1. ローカル変数（Loacal Values）
    1つ目はローカル変数で以下の特徴があります。
    - 式をかける
    - 外部から指定できない
    - デフォルト値は定義できない
1. 入力変数（Input Variables）
    2つ目は入力変数で以下の特徴があります。
    - 値のみ指定できる
    - 外部から指定できる
        - apply実行時に対話的に入力
        - コマンドラインから-varオプションや-ver-fileオプション
        - terraform.tfvarsファイル
        - 環境変数(TF_VAR_xxxなど)
    - デフォルト値の定義が可能

# 変数の作成方法とコードでの使用方法
1. ローカル変数（Loacal Values）
    ローカル変数は **locals** セクションで定義して **local.key名** の形式で使用します。ローカル変数は複数まとめて定義することができます。
    ```hcl
    locals {
      content  = "use local values."
      filename = "hello_local.txt"
    }
    resource "local_file" "helloworld" {
      content  = local.content
      filename = local.filename
    }
    ```
1. 入力変数（Input Variables）
    入力変数は **variable** セクションで定義して **var.key名** の形式で使用します。入力変数は1つずつ定義し、デフォルト値を定義することができます。
    ```hcl
    variable content {
      default = "use input variables default value."
    }
    variable filename {
      default = "default_var.txt"
    }
    resource "local_file" "helloworld" {
      content  = var.content
      filename = var.filename
    }
    ```

# ローカル変数を使用したファイル生成コードを作る

1. terraformコード作成する
    ローカル変数を使用するコードを作成します。
    ```hcl:helloworld_local.tf
    locals {
      content  = "use local values."
      filename = "hello_local.txt"
    }
    resource "local_file" "helloworld" {
      content  = local.content
      filename = local.filename
    }
    ```

1. plan
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_01.jpg)

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
