---
title: "フォルダで複数環境管理（エッセンス編） - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
Terraformで悩むのが環境の管理方法です。システムを開発する場合に本番環境のみということは非常に稀で、開発環境やステージング環境などの複数の環境を管理することがほとんどです。
複数の環境を管理する方法として最もメジャーなのが、環境ごとにフォルダをわける方法です。この記事では、フォルダを使った複数環境管理のエッセンスを説明します。
他の記事と同様にローカルPC上で完結するコードを使います。より実践的なコードは別の記事（誠意作成中）を参照してください。

# ゴール
開発、ステージング、本番の3つの環境にモジュールを使ってファイルを作成する。
![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_goal.jpg)

# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境
- 変数とモジュールの理解
   :::message
   変数とモジュールに自信のない方は以下の記事をどうぞ。
   - [変数の使い方](https://zenn.dev/sway/articles/terraform_biginner_varliable)
   - [モジュールの使い方](https://zenn.dev/sway/articles/terraform_biginner_modules)
   :::

# 特徴
## 説明
環境ごとにフォルダを作成し、設定ファイルなどを環境ごとに作成します。
リソース定義はモジュールフォルダに配置し、環境フォルダからモジュールとして参照します。
このような構成とすることで環境ごとの違いを管理しつつ、リソース作成を共通化することができます。

## ソース配置イメージ
フォルダ構造とソース配置のイメージは以下の通りです。
```
terraform/
 ├─── envs/
 │    ├─── develop/
 │    │    ├─ main.tf
 │    │    └─ setting.tf
 │    ├─── staging/
 │    │    ├─ main.tf
 │    │    └─ setting.tf
 │    └─── production/
 │    │    ├─ main.tf
 │    │    └─ setting.tf
 └─── modules/
      └─── hello/
           └─ helloworld.tf
```

## 環境ごとのソースの例
設定ファイルを環境ごとに作成します。
```hcl:envs/develop/setting.tf
locals {
  file = {
    content  = "hello world in develop!"
    filename = "../../output/develop/develop.txt"
  }
}
```
モジュールの呼び出しは環境ごとに定義します。冗長に感じるかもしれませが、特定の環境にのみ存在するリソースなどの管理も行いやすくなります。
```hcl:envs/develop/main.tf
module "develop_main" {
  source   = "../../modules/hello"
  content  = local.file.content
  filename = local.file.filename
}
```

## まとめ
- 設定は環境ごとにフォルダをわけて個別に作る
- リソースの定義はモジュール化して共通化する
- フォルダ構成でどのような環境があるかわかる
- 環境フォルダのソース差分を見ることで違いを比較しやすい

# サンプルコードによる実演

1. サンプルコード
   この記事で使用するコードはgithub上に公開しています。
   @[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_biginner_envbyfolder)

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
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_01.jpg)
   設定通りにoutput/develop/develop.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_02.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_03.jpg)

1. ステージング環境のファイル作成
   同じようにステージング環境のファイルも作成します。
   ```bash
   cd ..\staging
   terraform.exe init
   terraform.exe apply
   ```
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_04.jpg)
   設定通りにoutput/staging/staging.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_05.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_06.jpg)

1. 本番環境のファイル作成
   本番環境も同様です。
   ```bash
   cd ..\production
   terraform.exe init
   terraform.exe apply
   ```
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_07.jpg)
   設定通りにoutput/production/production.txtが作成されています。
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_08.jpg)
   ファイルの内容も指定の通りです。
   ![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_tutorial_09.jpg)

# 感想
この記事で説明するフォルダ構成が、いちばんオーソドックスで実践的なTrraformの使い方だと思います。インフラ育ちでコーディングに慣れていないメンバーがTerraformを使い始めた場合は、この管理方法を薦めることが多いです。

# 次はこれをやろう
1. フォルダで複数環境管理（実践編）
1. ワークスペースの使い方(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
