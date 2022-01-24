---
title: "Terraformのきほんと応用"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者"]
published: true
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraformといえばクラウドリソースの作成ですが、「Terraformのきほん」の記事はローカルPC上のリソース作成で済むように工夫しています。
今後に追加する予定の記事もタイトルだけあげています。書く順番は決めてないのですが、要望を頂ければ優先度を上げますので感想など頂ければと思います。

# Terraformのきほん
1. [ローカルでhello world](https://zenn.dev/sway/articles/terraform_biginner_helloworld)
1. 最低限おさえておきたいTerraformのアーキテクチャー(鋭意作成中)
1. [変数の使い方](https://zenn.dev/sway/articles/terraform_biginner_varliable)
1. [モジュールの使い方](https://zenn.dev/sway/articles/terraform_biginner_modules)
1. ワークスペースの使い方(鋭意作成中)

# Terraformのソース管理パターン
1. 環境ごとにフォルダを分ける(鋭意作成中)
1. 環境ごとの設定をモジュールにする(鋭意作成中)

# Teraformのてっぱん
1. Terraformバージョンを固定する
1. tfstateはS3などの共有ストレージに保存する(鋭意作成中)

# 私的Teraformの書き方
一般的なプラクティスと異なる部分もあります。また、考えが変わることもあるので同じ記事を継続的に更新します。
1. [variable.tfとoutputs.tfを分けない](https://zenn.dev/sway/articles/terraform_style_onefile.md)
1. tfファイルはリソースのライフサイクルごとにわける(鋭意作成中)

# TerraformでAWS
1. TerraformでVPCなら無料で練習できる！(鋭意作成中)
1. TerraformでEC2(鋭意作成中)
1. TerraformでAurora(鋭意作成中)

# Terraform
1. ALB+EC2+RDSでWordPressを公開する
