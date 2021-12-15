---
title: "ローカルでhello world - Terraformのきほん"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
クラウドの登場でサーバー構築が手軽になり、同じようなサーバーを何度もつくることになりました。この手間をソフトウェアによって解決してくれるのがTerraformです。
Terraformのコードを書くことで、サーバー構築を自動化して短時間で行うことができるようになります。
この記事では、ローカルファイルの作成を通してterraformのキホンを学べます。

# ゴール
terraformでローカルにhello.txtファイルを作成します。
ファイルの中身は「hellow world!」です。

# 必要なもの
- 作業時間：15分
- terraformをダウンロードして実行するためのインターネット接続環境
  :::message
  terraformは実行時にインターネットから追加モジュールをダウンロードする必要があります。
  :::
- zipファイルを解凍するためのツール
- カレントディレクトリ変更程度のCUIを扱える技術

# Terraformでhello worldを表示する

1. Terraformのダウンロード
[Terraformのダウンロードページ(https://www.terraform.io/downloads.html)](https://www.terraform.io/downloads.html)から、お使いの環境に応じたファイルをダウンロードします。
この記事ではwindows用をダウンロードして進めます。
![download terraform](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_01.jpg)

1. Terraformをインストール
ダウンロードファイルはzip形式になっています。解凍して任意の場所に配置すればインストールは完了です。
この記事では「c:\terraform」にインストールして進めます。
![install terraform](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_02.jpg)

1. Terraformの起動確認
コマンドプロンプトを起動して、カレントディレクトリをインストールフォルダに変更します。
terraformコマンドを実行して以下のスクリーンショットのようにコマンドの使い方が表示されればインストールは完了です。
![exec terraform](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_03.jpg)

1. ファイルを作成コードを追加する
    terraformをインストールしたディレクトリに「hello.tf」を作成して以下の内容を記述します。
    ```hcl:hello.tf
    resource "local_file" "helloworld" {
        content  = "hello world!"
        filename = "hello.txt"
    }
    ```

1. 初期化処理を実行する
    Terraformインストールフォルダで「init」コマンドを実行します。
    ```
    terraform init
    ```
    コマンド実行が成功すると「Terraform has been successfully initialized!」と表示されて、Terraformインストールフォルダに追加のモジュールがダウンロードされます。
    ![exec terraform init](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_04.jpg)
    ![terraform folder files](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_05.jpg)

1. 実行結果を事前確認する
    実行結果を事前確認するための「plan」コマンドを実行します。
    ```
    terraform plan
    ```
    実行結果に追加するファイルのパラメーターが表示されます。
    また、下の方に「Plan: 1 to add, 0 to change, 0 to destroy.」と、1つのリソースが追加となる旨のサマリーが表示されます。
    ![dry run](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_06.jpg)

1. Terraformでファイルを作成する
    ファイルを作成するために「apply」コマンドを実行します。
    ```
    terraform apply
    ```
    実行するとplanコマンドと同様に変更内容が表示されたあと「Do you want to perform these actions?」と、実行を再確認する注意メッセージが表示されます。
    ![create hello world file](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_07.jpg)
    ここで「yes」を入力してエンターキーを押すと処理が行われます。
    ![enter yes](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_08.jpg)

1. 作成されたファイルを確認する
   インストールフォルダに「hello.txt」ファイルが作成されています。
   ファイルを開くと「hellow world!」が書き込まれています！
    ![terraform folder files](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_09.jpg)
    ![hello world file](/images/terraform_biginner_helloworld/terraform_biginner_helloworld_tutorial_10.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_helloworld)

# 次はこれをやろう
- 最低限おさえておきたいTerraformのアーキテクチャー(鋭意作成中)
- [変数の使い方](https://zenn.dev/sway/articles/terraform_biginner_varliable)
