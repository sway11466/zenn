---
title: "独自ドメイン名でサーバーを公開する - AWSをはじめからていねいに"
emoji: "📒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "Route53"]
published: false
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。

# 概要
記事で説明すること
作業の流れ
理由

# ゴール
取得したドメイン名でWordPress画面を表示する。

# 必要なもの
- 作業時間：xx分
- 構築にかかる費用：1000円～
- 運用にかかる費用：1000円～／年
    :::message
    EC2とRDSの無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は構築費で10円ぐらい、毎月5000円ぐらいかかります。
    [参考見積はこちら](https://calculator.aws/#/estimate?id=8d4e89ac81c0191bde443b20c3171d3af40c88ae)
    :::
- WordPressが動作しているEC2
    :::message
    WordPressを準備していない場合は以下の記事を参考にして構築しましょう。
    - [EC2とRDSでWordPressを動かしてみる](https://zenn.dev/sway/articles/aws_publish_wordpress)
    :::

# 登場する主なコンポーネント

1. Route53
    hogehoge

1. ホストゾーン

# ドメイン名でアクセスする

## ドメイン名を取得する

1. ドメイン名を取得するためのRoute53サービスを取得する
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_01.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_02.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_03.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_04.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_05.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_06.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_07.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_08.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_09.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_10.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_11.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_12.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_13.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_14.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_15.jpg)

## Aレコードを登録する

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_16.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_17.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_18.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_19.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_20.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_21.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_22.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_23.jpg)

1. hoge
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_24.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/[article_title]])

# 次はこれをやろう
- [次の記事のタイトル](https://zenn.dev/sway/articles/)
