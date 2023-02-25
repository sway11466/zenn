---
title: "モジュールの使い方 - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
Terraformを使用しているとコードを再利用したくなります。インストールするソフトウェアが違うだけのサーバーを複数作成する場合などです。ファイルをコピーして対応しても良いのですが、変更が発生した場合に複数修正が必要になってしまい面倒です。
このような場合にはモジュール機能を使用します。この記事では、ローカルにファイルを作成するコードをモジュール化します。

# ゴール
ファイル作成モジュールを使って、２つのファイルを作成します。
![goal](/images/terraform_biginner_modules/terraform_biginner_modules_goal.jpg)

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# モジュールとは
Terraformではソースコードをモジュール化することで、テンプレートとして使うことができるようになります。テンプレートとは何でしょうか？日本語では定型文やひな形という意味になり、何かを作成する際の基礎にできる物をさします。
Terraformでは、サーバーを作成するソースコードをモジュール化してテンプレートにすることで、同じサーバーを１つのソースコードから複数つくる事ができます。
また、テンプレートにはパラメーターを指定することができるため、ほとんど同じだけど少し設定が異なるサーバーを１つのソースコードとして管理することができるのです。 

# モジュールの使い方
モジュールは親となるソースコードから呼び出します。
![use modules](/images/terraform_biginner_modules/terraform_biginner_modules_usage_01.jpg)
異なる親から同じモジュールを呼び出すこともできます。
![use modules from multi parent](/images/terraform_biginner_modules/terraform_biginner_modules_usage_02.jpg)
モジュールの呼び出し時にパラメーターを使うことで、ふるまいを制御することもできます。
![use modules with parameter](/images/terraform_biginner_modules/terraform_biginner_modules_usage_03.jpg)
モジュールを呼び出すコードは以下のように書きます。
```hcl
module "リソースの名前" {
    source = "モジュールを定義したフォルダのパス"
    パラメーター名 = "パラメーター値"
}
```

# モジュールの作り方

1. モジュールの構造
    モジュールは以下の３つで成り立っています。
    1. パラメーター
    1. 本体
    1. 戻り値
    ![modules structure](/images/terraform_biginner_modules/terraform_biginner_modules_structure_01.jpg)

1. パラメーターを定義する
    パラメーターを定義することにより、親から受け取った値を本体で使用することができます。
    パラメーターは「variable」で定義します。
    ```hcl
    variable "parameter_name" {
    }
    ````
    複数のパラメーターを定義することもできます。
    ```hcl
    variable "parameter_1" {
    }
    variable "parameter_2" {
    }
    ````

1. パラメーターを使用する
    パラメーターを本体で使用する場合は「var.パラメーター名」を使用します。
    ```hcl
    resource "リソース定義名" "リソース名" {
        item_a = var.parameter_1
        item_b = var.parameter_2
    }
    ```

1. 戻り値について
    戻り値を定義すると、モジュールを呼び出した親でその値を使用することができます。
    戻り値は「output」で定義します。
    ```hcl
    output "debug_print" {
      value = "create from module with ${var.parameter_1}."
    }
    ```
    本記事では戻り値については詳細に説明しません。

# モジュール化したファイル作成コードで複数のファイルを作成する

1. terraformコード作成する
    最終的なファイル構成は以下の通りです。
    ```
    terraform/
    ├─ main1.tf
    ├─ main2.tf
    ├─ terraform.exe
    └─ modules/
      └─ helloworld.tf
    ```
    順番にファイルを作成します。
    ```hcl:main1.tf
    module "module_sample_main" {
      source = "./modules"
      content = "hello world!"
      filename = "hello.txt"
    }
    ```
    ```hcl:main2.tf
    module "module_sample_foobar" {
      source = "./modules"
      content = "foo bar!"
      filename = "foobar.txt"
    }
    ```
    ```hcl:modules/helloworld.tf
    variable "content" {
    }

    variable "filename" {
    }

    resource "local_file" "helloworld" {
        content  = var.content
        filename = var.filename
    }

    output "debug_print" {
      value = "${var.content} to ${var.filename}"
    }
    ```

1. 実行結果を事前確認する
    実行結果を事前確認するために「plan」コマンドを実行します。
    ```
    terraform plan
    ```
    ファイル foobar.txt と hello.txt が作成されそうです。
    ![exec plan](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_01.jpg)

1. 実行してファイルを作成する
    ファイルを作成するために「apply」コマンドを実行します。
    ```
    terraform apply
    ```
    ![exec plan](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_02.jpg)
    以下の通り2つのファイルが作成されました。
    ![exec plan](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_03.jpg)
    ファイルの内容もパラメーターで指定した通りです。
    ![exec plan](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_04.jpg)
    ![exec plan](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_05.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_modules)

# 参考ページ
- Terraformオフィシャルの入力変数の説明
    @[card](https://www.terraform.io/language/values/variables#variable-definitions-tfvars-files)

# 次はこれをやろう
- [モジュールの使い方](https://zenn.dev/sway/articles/terraform_biginner_modules)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
