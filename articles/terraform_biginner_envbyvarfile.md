---
title: "パラメーターファイルで複数環境管理 - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者", "複数環境"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
Terraformで複数環境を管理するための方法は多種多様という状況で、様々な状況において圧倒的に優れている方法は存在していません。
この記事では、その方法の1つであるパラメーターファイルを使用する方法を説明します。
他の記事と同様にローカルPC上で完結するコードを使います。より実践的なコードは別の記事（鋭意作成中）を参照してください。

# ゴール
環境の管理にパラメーターファイルを使って、開発、ステージング、本番の3つの環境にファイルを作成する。
![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_goal.jpg)

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境
- 変数とbackendの動的設定の理解
   :::message
   変数に自信のない方は以下の記事をどうぞ。backendの動的設定の記事は鋭意作成中です。
   - [変数の使い方](https://zenn.dev/sway/articles/terraform_biginner_varliable)
   :::

# 特徴
## 説明
環境ごとにパラメーターファイルを作成し、terraform実行時のパラメーターを指定します。

## ソース配置
フォルダ構造とソース配置は以下の通りです。
envsフォルダの作成は必須ではありませんが、環境ごとのファイルという意図が伝わりやすいようにあえてフォルダを作成しています。
```
terraform/
 ├─── envs/
 │    ├─── develop.tfbackend
 │    ├─── develop.tfvars
 │    ├─── production.tfbackend
 │    ├─── production.tfvars
 │    ├─── staging.tfbackend
 │    └─── staging.tfvars
 ├─ main.tf
 └─ helloworld.tf
 ```

## 環境ごとの設定ファイル
設定ファイルを環境ごとに作成します。
```hcl:envs/develop.tfvars
env = develop
file = {
  content  = "hello world in develop!"
  filename = "output/develop/develop.txt"
}
```

## 実行
「-backend-config」
かならず切り替える必要がある。
```bash
terraform init -backend-config="envs/develop.tfbackend"
```
「-var-file」
```bash
terraform plan -var-file="envs/develop.tfvars"
```

## まとめ
- 設定ファイルを環境ごとに作る
- initでtfstateの切り替が必須（重要）
- planやapply実行時に-var-fileを使用する

# サンプルコードによる実演

1. サンプルコード
   この記事で使用するコードはgithub上に公開しています。
   @[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_envbyvarfile)

1. 開発環境のファイル作成
   開発環境はoutput/develop/develop.txtを作成する設定にします。
   ```hcl:envs/develop/setting.tf
   locals {
     file = {
       content  = "hello world in develop!"
       filename = "../../output/develop/develop.txt"
     }
   }
   ```
   カレントディレクトリを開発フォルダに変更してinit、applyを実行します。
   ```bash
   cd envs\develop
   terraform.exe init
   terraform.exe apply
   ```
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_01.jpg)
   設定通りにoutput/develop/develop.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_02.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_03.jpg)

1. ステージング環境のファイル作成
   同じようにステージング環境のファイルも作成します。
   ```bash
   cd ..\staging
   terraform.exe init
   terraform.exe apply
   ```
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_04.jpg)
   設定通りにoutput/staging/staging.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_05.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_06.jpg)

1. 本番環境のファイル作成
   本番環境も同様です。
   ```bash
   cd ..\production
   terraform.exe init
   terraform.exe apply
   ```
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_07.jpg)
   設定通りにoutput/production/production.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_08.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_09.jpg)

# 感想
この記事で説明するフォルダ構成が、いちばんオーソドックスで実践的なTrraformの使い方だと思います。インフラ育ちでコーディングに慣れていないメンバーがTerraformを使い始めた場合は、この管理方法を薦めることが多いです。

# 次はこれをやろう
1. [フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder)
1. パラメーターファイルで複数環境管理（実践編）(鋭意作成中)
1. ワークスペースで複数環境管理（エッセンス編）(鋭意作成中)
1. mapとfor_eachでまとめてオブジェクトを作成する(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
