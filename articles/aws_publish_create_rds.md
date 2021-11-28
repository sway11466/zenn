---
title: "RDSデータベースを構築する - AWSをはじめからていねいに"
emoji: "📒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "RDS", "初心者"]
published: false
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
[AWS記事の一覧](https://zenn.dev/sway/articles/aws_index_list)

# 概要
？？？
RDS構築
EC2にMySQLインストール
接続

# ゴール
？？？
![Goal](/images/aws_publish_create_rds/aws_publish_create_rds_goal.jpg)

# 必要なもの
- 作業時間：30分
- 費用：無料※
    :::message
    RDSの無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は5円ぐらいかかります。
    :::
- AWSアカウント
- EC2
    RDSへの接続に使用します。構築していない場合は「[とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)」を参考に構築してください。

# 登場する主なコンポーネント

1. RDS
    AWSの仮想サーバーです。課金が秒単位のため必要なときだけ起動して使い終わったら停止することで費用を節約することができます。

# EC2の作成手順

1. RDSダッシュボードを表示する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「データベース」を選択します。表示されるサブメニューから「RDS」を選択します。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_01.jpg)

1. データベースの作成を開始する
    「データベースの作成」ボタンを押してデータベースの作成を開始します。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_02.jpg)

1. データベースの設定を入力する①
    「データベース作成方法を選択」は「簡単に作成」を選択します。「設定」は「MySQL」を選択します。「DBインスタンスサイズ」は「無料利用枠」を選択します。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_03.jpg)

1. データベースの設定を入力する②
    「DBインスタンス識別子」は自由に設定します。思いつかなければ「mysql」をいれます。「マスターユーザー名」も自由に設定して構いませんが「admin」のままでも構いません。「マスターパスワード」も自由に設定します。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_04.jpg)

1. データベースが作成されるのを待ちます
    データベース一覧に切り替わりデータベース作成中の状態になるので、作成が完了するまで待ちます。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_05.jpg)

1. 作成されたデータベースを確認します
    データベースが作成されたら完了です。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_06.jpg)

1. EC2にセッションマネージャーで接続する
   EC2にセッションマネージャーで接続します。セッションマネージャーでの接続方法がわからない場合は「[とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)」の「手順20. EC2に接続する」を確認してください。

1. EC2にMySQL接続するためのソフトウェアをインストールする

1. 

# 感想
個人的にはRDSならAurora一択なのですが（記事を作成予定）、残念なことに無料枠が準備されていません。
初心者向けにAWS記事で有料サービスを使用するのはハードルが高いと考えて無料枠のあるRDSにしました。
Auroraの無料枠作ってくれないかな。。。

# 次はこれをやろう
- EC2とRDSでWordPressを動かしてみる(鋭意作成中)
