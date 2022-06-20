---
title: "mapとfor_eachで複数オブジェクトを作成する - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["tags"]
published: false
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
記事で説明すること
作業の流れ
理由

# ゴール
mapとfor_eachを使って複数のファイルを作成します。
![goal](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_goal.jpg)

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# terraformで複数オブジェクトを作るには
- 設定値が少しだけ異なるオブジェクトを複数作成したいシチュエーションが発生する
    - subnet（アドレス帯のみが異なる）
    - 開発ユーザー（ロールが少しづつ異なる）
- mapでオブジェクトを定義
- for_eachで

# map型で設定値を管理値するメリット
map型は「項目名＝値」の形式となるため意味を理解しやすいというメリットがあります。 コードを書いている瞬間は些細な事と感じるかもしれませんが、これは保守性に絶大な影響を与えます。
たとえば、初見のソースの設定ファイルが以下であった場合、この値がどのように使われていてるか推測しやすいのではないでしょうか。
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

# for_eachの文法
map型の設定から複数のオブジェクトを効率よく作成するにはfor_each機能を使用します
※ このソースは架空のリソース定義です
- リソース定義に含める
- each.keyでキー要素にeach.valueでオブジェクトにアクセスする
```hcl:network.tf
resource "subnet" "subnets" {
  for_each = local.subnets
  name     = each.key
  az       = eavch.value.az
  cidr     = eavch.value.cidr
  public   = eavch.value.public
}
```

# mapとfor_eachによる複数オブジェクト作成の方法

1. mapで
    ファイル名と内容が異なるファイルを複数作成するための定義を作成します。
    ```hcl
    locals {
        files = {
            "hello.txt" = {
                content = "hello wolrd."
            }
            "foo.txt" = {
                content = "foo bar."
            }
        }
    }
    ````

1. for_each
    ファイルを作成するリソース定義をfor_eachで複数作成します。
    ```hcl
    resource "local_file" "local_sample" {
    for_each = local.files
    filename = each.key
    content  = each.value.content
    }
    ````

1. 実行結果を事前確認する
    実行結果を事前確認するために「plan」コマンドを実行します。
    ```
    terraform plan
    ```
    ファイル foobar.txt と hello.txt が作成されそうです。
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_01.jpg)

1. 実行してファイルを作成する
    ファイルを作成するために「apply」コマンドを実行します。
    ```
    terraform apply
    ```
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_02.jpg)
    以下の通り2つのファイルが作成されました。
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_03.jpg)
    ファイルの内容もパラメーターで指定した通りです。
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_04.jpg)
    ![exec plan](/images/terraform_biginner_multiple_object/terraform_biginner_multiple_object_tutorial_05.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_multiple_object)

# 次はこれをやろう
- [フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder)
- [ネストしたオブジェクトを型指定で受け取る](https://zenn.dev/sway/articles/terraform_tips_nestobjarg)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
