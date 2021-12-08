---
title: "モジュールの使い方 - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: false
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
このの記事はローカルで行えるように工夫しています。クラウドを使わずに無料で学べます。
[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)

# 概要
説明
ちなみに、この記事で説明するファイル構成はモジュールを理解するための

# ゴール
モジュール化したファイル作成コードで2つのファイルを作成する。

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# モジュールとは
Terraformではソースコードをモジュール化することで、テンプレートとして使うことができるようになります。
テンプレート化とは何でしょうか？日本語では定型文やひな形という意味になり、何かを作成する際の基礎にできる物をさします。
たとえば、サーバーを作成するソースコードをモジュール化してテンプレートにしておくことで、インストールするそうとウェアが少し違うサーバーを同じソースコードで実現することができます。

# モジュールの使い方
モジュールは親となるソースコードから呼び出します。
![use modules](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_01.jpg)
異なる親から同じモジュールを呼び出すこともできます。
![use modules from multi parent](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_02.jpg)
モジュールの呼び出し時にパラメーターを使うことで、ふるまいを制御することもできます。
![use modules with parameter](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_03.jpg)

# モジュールの構造
モジュールは以下の３つで成り立っています。
1. パラメーター定義
1. 本体
1. 戻り値
![modules structure](/images/terraform_biginner_modules/terraform_biginner_modules_tutorial_04.jpg)

# モジュール化したファイル作成コードで複数のファイルを作成する

1. ファイルを作成するterraformソースを準備する
    ```hcl:hello.tf
    resource "local_file" "helloworld" {
        content  = "hello world!"
        filename = "hello.txt"
    }
    ```

1. Terraformのダウンロード
![download terraform](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_01.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_modules)

# 次はこれをやろう
- 環境ごとにフォルダを分ける(鋭意作成中)
- ワークスペースの使い方(鋭意作成中)
