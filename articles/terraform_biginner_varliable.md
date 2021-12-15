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
Terraformではプログラミング言語のように変数を定義することができます。
変数を使うことで、ソースコードを読みやすくしたり実行時に値を指定することができます。
この記事では、変数を使ってローカルファイルを作成します。

# ゴール
ファイル名と中身を変数で指定してファイルを作成する。

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# 変数の種類と特徴
Terraformには2種類の変数があります。
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
        - コマンドライン実行時の-varオプションや-ver-fileオプション
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
    resource "local_file" "local_sample" {
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
      default = "default_input.txt"
    }
    resource "local_file" "input_sample" {
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
    resource "local_file" "local_sample" {
      content  = local.content
      filename = local.filename
    }
    ```

1. 実行結果を事前確認する
    実行結果を事前確認するための「plan」コマンドを実行します。ローカル変数を使用してファイルを作成できそうです。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_01.jpg)

1. 実行してファイルを作成する
    ファイルを作成するために「apply」コマンドを実行します。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_02.jpg)
    ファイルが作成されています。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_03.jpg)
    ファイルの中身もローカル変数で指定した通りです。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_04.jpg)

# 入力変数を使用したファイル生成コードを作る

1. terraformコード作成する
    入力変数を使用するコードを作成します。
    ```hcl:helloworld_input.tf
    variable content {
      default = "use input variables default value."
    }
    variable filename {
      default = "default_input.txt"
    }
    resource "local_file" "input_sample" {
      content  = var.content
      filename = var.filename
    }
    ```

1. デフォルト値での実行結果を事前確認する
    実行結果を事前確認するための「plan」コマンドを実行します。入力変数のデフォルト値を使用してファイルを作成できそうです。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_05.jpg)

1. デフォルト値でファイルを作成する
    ファイルを作成するために「apply」コマンドを実行します。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_06.jpg)
    ファイルが作成されています。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_07.jpg)
    ファイルの中身もローカル変数で指定した通りです。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_08.jpg)

1. 実行時に値を指定して事前確認する
    入力変数の値をコマンド実行時に指定して事前確認します。先ほど作成したデフォルト値のファイルの置き換えで、指定した入力変数を使用してファイルを作成しそうです。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_09.jpg)

1. 実行時に値を指定してファイルを作成する
    ファイルを作成するために「apply」コマンドを実行します。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_10.jpg)
    ファイルが作成されています。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_11.jpg)
    ファイルの中身は実行時に指定した通りです。
    ![image title](/images/terraform_biginner_varliable/terraform_biginner_varliable_tutorial_12.jpg)

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
