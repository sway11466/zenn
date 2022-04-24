---
title: "パラメーターファイルで複数環境管理 - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者", "複数環境"]
published: false
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
- 作業時間：30分
- Terraformを実行できる環境
- 変数とbackendの動的設定の理解
   :::message
   変数に自信のない方は以下の記事をどうぞ。backendの動的設定の記事は鋭意作成中です。
   - [変数の使い方](https://zenn.dev/sway/articles/terraform_biginner_varliable)
   :::

# 特徴
## 説明
「plan」や「apply」を実行する際に「-var-file」オプションで環境ごとに作成したパラメーターファイルを指定します。これだけなら非常に簡単なのですが、実行する前にtfstateも環境ごとに切り替える必要があります。
なぜかというとterraformはtfstateを使って構築したリソースを管理しており、例えばtfstateが本番環境を指している状況で開発環境のパラメーターファイルを指定して「apply」を実行すると大惨事となります。（本番環境のリソースを削除して開発環境として作り直す挙動が予想されます）
tfstateの切り替えは「terraform init」に「-backend-cnfig」オプションを使用して実現します。すでに別の環境を指している場合は「-reconfigure」オプションも使います。

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
環境ごとに2つの設定ファイル「.tfbackend」と「.tfvars」を作成します。
「.tfbackend」にはtfstateのパスを定義します。
```hcl:envs/develop.tfbackend
path = "tfstate/develop/terraform.tfstate"
```
「.tfvars」には作成するファイルパスとファイルの内容を定義します。
```hcl:envs/develop.tfvars
env = "develop"
file = {
  content  = "hello world in develop!"
  filename = "output/develop/develop.txt"
}
```

## 実行方法
まずは「terraform init」を「-backend-config」オプションを指定して実行します。
```bash
terraform init -backend-config="envs/develop.tfbackend"
```
環境の切り替えなど2回目移行は「-reconfigure」オプションも必要になります。
```bash
terraform init -reconfigure -backend-config="envs/develop.tfbackend"
```
初期化後は「-var-file」を指定して「plan」や「apply」を実行します。
```bash
terraform plan -var-file="envs/develop.tfvars"
```

## まとめ
- **実行前にtfstateを切り替える（重要）**
- 実行時に設定ファイルを指定する

# サンプルコードによる実演

1. サンプルコード
   この記事で使用するコードはgithub上に公開しています。
   @[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_envbyvarfile)

1. 開発環境のファイル作成
   開発環境の設定は以下の通りです。
   tfstateのパスとして「tfstate/develop/terraform.tfstate」を指定します。
   ```hcl:envs/develop.tfbackend
   path = "tfstate/develop/terraform.tfstate"
   ```
   「.tfvars」には作成するファイルパスとファイルの内容を定義します。
   ```hcl:envs/develop.tfvars
   env = "develop"
   file = {
     content  = "hello world in develop!"
     filename = "output/develop/develop.txt"
   }
   ```
   init、applyを実行します。
   ```bash
   terraform.exe init -backend-config="envs/develop.tfbackend"
   terraform.exe apply -var-file="envs/develop.tfvars"
   ```
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_01.jpg)
   設定通りにtfstate/develop/terraform.tfstateとoutput/develop/develop.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_02.jpg)
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_03.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_04.jpg)

1. ステージング環境のファイル作成
   同じようにステージング環境のファイルも作成します。開発環境構築後なので「init」実行時に「-reconfigure」を指定します。
   ```bash
   terraform.exe init -reconfigure -backend-config="envs/staging.tfbackend"
   terraform.exe apply -var-file="envs/staging.tfvars"
   ```
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_05.jpg)
   設定通りにtfstate/staging/terraform.tfstateとoutput/staging/staging.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_06.jpg)
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_07.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_08.jpg)

1. 本番環境のファイル作成
   最後は本番環境です。
   ```bash
   terraform.exe init -reconfigure -backend-config="envs/production.tfbackend"
   terraform.exe apply -var-file="envs/production.tfvars"
   ```
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_09.jpg)
   設定通りにoutput/production/production.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_10.jpg)
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_11.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyvarfile/terraform_biginner_envbyvarfile_tutorial_12.jpg)

# 感想
Terraformに慣れてtfstateが理解できるようになっていれば扱いやすい構成だと思います。私もこの構成をベースにモジュール化して使用することが多くあります。

# 次はこれをやろう
1. パラメーターファイルで複数環境管理（実践編）(鋭意作成中)
1. [フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder)
1. ワークスペースで複数環境管理（エッセンス編）(鋭意作成中)
1. mapとfor_eachでまとめてオブジェクトを作成する(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
