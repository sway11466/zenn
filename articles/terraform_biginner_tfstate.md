---
title: "tfstateにふれてみよう - Terraformのきほん"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
Terraformを運用していくにはtfstateの理解が必要になってきます。tfstateはTerraformによって構築したリソースを記録するためのデータベースです。
この記事では、tfstateの中身を確認したり（テキストファイルです）、tfstateを削除した場合の挙動を確認したりします。

# ゴール
terraformにおけるtfstateの位置づけを理解する。

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境

# tfstateとは
terraformで意識が向くのはソースコードとクラウド上のリソースのため、以下のようなアーキテクチャーであると想定してしまいがちです。
![imaginary architecture](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_00.jpg)
しかし、実際はtfstateと呼ばれるデータベースを持っており以下のようなアーキテクチャーとなっています。
![acutually architecture](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_01.jpg)
このようなアーキテクチャーを採用している理由は、メタデータの管理やパフォーマンスのためのようです。
原典にあたりたいかたはこちらからどうぞ（英語ですが）。
@[card](https://www.terraform.io/language/state/purpose)

# tfstateにふれてみる
1. まずは普通にinit/plan/applyでテキストファイルを作る
    読み取り専用のhello.txtファイルを生成するソースコードを使用します。
    ```hcl:hello.tf
    resource "local_file" "helloworld" {
        content         = "hello world!"
        filename        = "hello.txt"
        file_permission = "0555"
    }
    ```
    init/plan/applyしてファイルを作成します。
    ![run helloworld.tf](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_02.jpg)
    hello.txtファイルが作成されています。
    ![output files](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_03.jpg)
1. tfstateの中身を確認する
    今回の主役である「terraform.tfstate」ファイルの中身を確認しましょう。テキストファイルなので好きなエディタで確認することができます。
    ![show tfstate](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_04.jpg)
    ソースコードに対応したテキストファイルの設定値や、applyで生成した際に与えられたidが記録されています。
    ![images](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_05.jpg)
1. tfstateを削除してplan/applyする
    この状態でtfstateを削除してplanやapplyを実行するとどうなるでしょうか？
    まずは「terraform.tfstate」ファイルを削除します。
    ![delet tfstate](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_06.jpg)
    そしてplanを実行してみます。
    ![run plan](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_07.jpg)
    tfstateが存在していないためファイル未作成と判断され、ファイルを新規に作成するplanが表示されます。
    この状態でapplyを実行してみます。
    ![run plan](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_08.jpg)
    すでにファイルが存在するためファイルの作成時にエラーが発生します。
    この状態のtfstateの中身を確認すると構築したリソースが空っぽになっています。
    ![run plan](/images/terraform_biginner_tfstate/terraform_biginner_tfstate_tutolial_09.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_tfstate)

# 次はこれをやろう
1. ワークスペースの使い方(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
