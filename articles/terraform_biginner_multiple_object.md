---
title: "mapとfor_eachで複数オブジェクトを作成する - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "for_each", "map"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
terraformを使用していると、だいたい同じだけど少しだけ設定が違うオブジェクトを複数作りたい場合が出てきます。例えば、サブネット（ciderが異なる）、ユーザー（IDが異なる）などです。
このような場合にはfor_eachを使用します。また、差分となる設定はmap形式で定義するとソースが読みやすく保守性が高くなります。
この記事では、map形式の設定とfor_eachを使ってローカルに複数のファイルを作成します。

# ゴール
mapとfor_eachを使って複数のファイルを作成します。

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# map型で設定値を定義する
map型は「項目名＝値」の形式で定義します。わかりやすい項目名をつけることで理解しやすくなります。 コードを書いている瞬間は些細な事と感じるかもしれませんが、これは保守性に絶大な影響を与えます。
たとえば、設定ファイルに以下の用なブロックが定義されていた場合、この値がどのように使われていてるか推測しやすいのではないでしょうか。
```hcl:example_setting.tf
subnets = {
  "app" = { az = "1a", cidr = "10.1.0.0/24", public = true }
  "db"  = { az = "1c", cidr = "10.2.0.0/24", public = false }
}
users = {
  "admin" = { name = "admin", role = "admin" }
  "foo"   = { name = "foo",   role = "user" }
  "bar"   = { name = "bar",   role = "user" }
}   
```

# for_eachで複数オブジェクトの作成する
terraformで作成するすべてのリソースはfor_eachを指定することができます。
for_eachにはmap型の値を指定することができます。（Set型も指定できますが、この記事の対象外）
for_eachを指定したリソースでは以下の特別な変数を使用することができます。名前の通り項目名と値を表します。
- each.key
- each.value
```hcl:network.tf
// サブネットの定義（仮想です）
resource "subnet" "subnets" {
  for_each = local.subnets
  name     = each.key
  az       = eavch.value.az
  cidr     = eavch.value.cidr
  public   = eavch.value.public
}
```
本家のfor_each解説はこちら。（英語）
@[card](https://www.terraform.io/language/meta-arguments/for_each)

# mapとfor_eachによる複数ファイル作成の例

1. map型でファイルの情報を定義する
    ファイル名と内容が異なるファイルを複数作成するための定義を作成します。
    ```hcl
    locals {
      files = {
        "hello" = {
          name    = "hello.txt"
          content = "hello wolrd."
        }
        "foobar" = {
          name    = "foobar.txt"
          content = "foo bar."
        }
      }
    }
    ````

1. ファイル作成リソースにfor_eachを定義する
    ファイルを作成するリソース定義をfor_eachで複数作成します。
    ```hcl
    resource "local_file" "local_sample" {
      for_each = local.files
      filename = each.value.name
      content  = each.value.content
    }
    ````

1. 初期化処理を実行する
    「init」コマンドで初期化します。
    ```
    terraform init
    ```
    ![exec init](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_01.jpg)

1. 実行結果を事前確認する
    「plan」コマンドで実行結果を事前確認します。
    ```
    terraform plan
    ```
    ファイル foobar.txt と hello.txt が作成されそうです。
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_02.jpg)

1. 実行してファイルを作成する
    「apply」コマンドでファイルを作成します。
    ```
    terraform apply
    ```
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_03.jpg)
    以下の通り2つのファイルが作成されました。
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_04.jpg)
    ファイルの内容もパラメーターで指定した通りです。
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_05.jpg)
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_06.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_multiple_object)

# 次はこれをやろう
- [tfstateにふれてみよう](https://zenn.dev/sway/articles/terraform_biginner_tfstate)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
