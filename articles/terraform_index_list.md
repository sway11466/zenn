---
title: "Terraformのきほんと応用"
emoji: "📑"
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
1. [フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder)
1. ワークスペースの使い方(鋭意作成中)
1. backendをコマンドライン引数で指定する(鋭意作成中)

# Terraformの応用
1. 公式モジュール(Terraform Registory)の使い方(鋭意作成中)

# Teraformのてっぱん
Terraformを使う全ての人が実践すべき内容について説明します。
1. [Terraformバージョンを固定する](https://zenn.dev/sway/articles/terraform_staple_fixversion)
1. [tfstateはS3などの共有ストレージに保存する](https://zenn.dev/sway/articles/terraform_staple_sharestate)
1. tfstateのロック機能を使う(鋭意作成中)
1. 全てのリソースに一律でタグを入れる(鋭意作成中)

# 私的Teraformの書き方
私が好むTerraformの書き方です。一般的なプラクティスと異なる部分もあります。
1. [variable.tfとoutputs.tfを分けない](https://zenn.dev/sway/articles/terraform_style_onefile)
1. [入力変数でオブジェクト型を使う](https://zenn.dev/sway/articles/terraform_style_useobject)
1. tfファイルはリソースのライフサイクルごとにわける(鋭意作成中)
1. 環境ごとの設定をモジュールにする(鋭意作成中)

# Terraformコードベース
Terraformのひな形となるコードを公開しています。
1. [ALB+EC2+RDSのミニマル構成](https://zenn.dev/sway/articles/terraform_codebase_wordpress_minimal)
1. [フォルダで複数環境管理（実践編）](https://zenn.dev/sway/articles/terraform_codebase_wordpress_envbyfolder)
