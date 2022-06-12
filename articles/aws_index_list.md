---
title: "AWSをはじめからていねいに"
emoji: "📑"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "初心者"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
今後に追加する予定の記事もタイトルだけあげています。書く順番は決めてないのですが、要望を頂ければ優先度を上げますので感想など頂ければと思います。

# はじめてのAWS
とりあえず手を動かしてAWSを触ってみようという記事群です。無料枠を使用しているのでお金をかけずにAWSを練習することができます。
1. [AWSアカウントを作る](https://zenn.dev/sway/articles/aws_make_account)
1. [普段使いのIAMユーザーを作る](https://zenn.dev/sway/articles/aws_biginner_create_iam_user)
1. [とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)
1. [AWS CLIでS3を操作する](https://zenn.dev/sway/articles/aws_biginner_use_cli)
1. AWS CLIでセッションマネージャー接続する(鋭意作成中)
1. 利用料金を毎日通知する(鋭意作成中)

# AWSでWebサービスを公開しよう
No.3でWordPressを動かすまで無料枠のみで進められますが、No.4のドメイン名でのサーバーから費用が発生します。費用が発生するサービスも実践向きなものは構築手順をスクリーンショット満載でお届けします。
1. [RDSでデータベースを構築する](https://zenn.dev/sway/articles/aws_publish_create_rds)
1. [EC2にApacheをインストールしてブラウザで表示する](https://zenn.dev/sway/articles/aws_publish_apache)
1. [EC2とRDSでWordPressを動かしてみる](https://zenn.dev/sway/articles/aws_publish_wordpress)
1. [独自ドメイン名でサーバーを公開する](https://zenn.dev/sway/articles/aws_publish_original_domain)
1. ALB配下でEC2を動かす(鋭意作成中)
1. サーバーダウンを検知する(鋭意作成中)
1. WAFで攻撃から守る(鋭意作成中)
1. サービスの利用者数をCloudWatchで監視する(鋭意作成中)
- 番外編 EC2を再起動してWordPressの表示がおかしくなったら(鋭意作成中)

# ていねいに理解するAWS
1. インフラ管理はペットから家畜へ(鋭意作成中)
1. AWSのサービスの種類をいろいろな切り口で(鋭意作成中)
1. VPCネットワークの基礎(鋭意作成中)
1. むずかしいIAMを理解するポイント(鋭意作成中)
1. 最低限のS3設定(鋭意作成中)

# AWSでCICD
1. CodeCommitでソースを管理する(鋭意作成中)

# わたしのAWS設計
1. セキュリティグループはリソースごとに作る！(鋭意作成中)
1. IAMロールはリソースごとに作る！(鋭意作成中)
1. AWSセキュリティの私的ベストプラクティス(鋭意作成中)
1. 個人的にはRDSならAurora一択(鋭意作成中)

# AWSを使い倒す
1. 個人利用でも300USD無料クレジットを使おう(鋭意作成中)

# AWSの実装例
Terraformで構築するAWSの実装例
1. [ALB+EC2+RDSのミニマル構成](https://zenn.dev/sway/articles/terraform_codebase_wordpress_minimal)
1. [ALB+EC2+AuroraでMattermost](https://zenn.dev/sway/articles/terraform_codebase_mattermost)

# 記事の方向性を検討中のもの
- ECS
- EKS
- Lambda
- Amplify
- 可用性設計

# 別の記事たち
- [Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)
