---
title: "フォルダで環境分割（エッセンス編） - Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: false
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、この記事ではローカルPC上のリソース作成で済むように工夫しています。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
・Terraformをある程度理解すると環境ごとに管理したくなる
・なぜなら少しずつ設定が違うから
    ・スペックとか
・本記事ではモジュール機能を使用することでフォルダで環境を分ける場合のエッセンスを説明する

# ゴール
開発、ステージング、本番の３つの環境にモジュールを使ってファイルを作成する。
![goal](/images/terraform_biginner_envbyfolder/terraform_biginner_envbyfolder_goal.jpg)


# 必要なもの
- 作業時間：15分
- Terraformを実行できる環境
- モジュールの理解

# ソース配置イメージ
フォルダ構造とソース配置のイメージは以下の通りです。
```
terraform/
 ├─── envs/
 │    ├─── develop/
 │    │    └─ main.tf
 │    ├─── staging/
 │    │    └─ main.tf
 │    └─── production/
 │         └─ main.tf
 └─── modules/
      └─ helloworld.tf
```

# 環境ごとにファイルを作成する

1. 開発環境のファイル作成

1. ステージング環境のファイル作成

1. 本番環境のファイル作成

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/[article_title]])

# 次はこれをやろう
1. フォルダで環境分割（実践編）
1. ワークスペースの使い方(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
