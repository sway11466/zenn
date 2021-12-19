---
title: "EC2にApacheをインストールしてブラウザで表示する - AWSをはじめからていねいに"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["tags"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。

# 概要
EC2でWebサービスを公開するにはApacheなどのWebサーバーをインストールしてインターネットからアクセスできるように設定する必要があります。
この記事では、Apacheのインストールとセキュリティグループの設定を行ってブラウザからEC2にアクセスする流れを説明します。

# ゴール
EC2にインストールしたApacheをブラウザで表示する。
![image title](/images/aws_publish_apache/aws_publish_apache_goal.jpg)

# 必要なもの
- 作業時間：15分
- 費用：無料※
    :::message
    EC2の無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は5円ぐらいかかります。
    :::
- ApacheをインストールするEC2
    :::message
    準備していない場合は以下の記事を参考にして構築してください。
     [とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)
    :::

# 登場する主なコンポーネント
- セキュリティグループ
セキュリティグループはIPアドレスとポート番号によるファイアーウォールです。セキュリティグループは付与する対象（今回はEC2）に入ってくる接続と、対象から出ていく接続にそれぞれ設定が必要となります。入ってくる接続をインバウンドルール、出ていく接続をアウトバウンドルールと言います。
- インバウンドルールのイメージ
この記事では、ブラウザからApacheを起動するために80ポートのアクセスを許可するためのインバウンドルールを設定します。
![image title](/images/aws_publish_apache/aws_publish_apache_description_sg_01.jpg)
- アウトバウンドルールのイメージ
![image title](/images/aws_publish_apache/aws_publish_apache_description_sg_02.jpg)

# Apacheをインストールしてブラウザ表示する

1. Apacheをインストールする
    yumコマンドでApacheをインストールします。
    ```
    sudo yum install httpd -y
    ```
    ![install apache](/images/aws_publish_apache/aws_publish_apache_tutorial_01.jpg)

1. Apacheを起動する
    systemctlコマンドでApacheを起動します。
    ```
    sudo systemctl start httpd
    ```
    ![start apache](/images/aws_publish_apache/aws_publish_apache_tutorial_02.jpg)

1. EC2上から接続確認する
    EC2サーバー自身でApacheに接続できるかテストします。
    テストはcurlコマンドで行います。コンテンツを全部みたくないのでheadを通しします。
    ```
    curl http://localhost | head
    ```
    以下のようにhtmlソースが表示されれば正常に起動しています。
    ![test apache form local](/images/aws_publish_apache/aws_publish_apache_tutorial_03.jpg)

1. ブラウザ接続するためのURLを調べる
    EC2ダッシュボードでインスタンスを選択すると詳細欄が表示されるので、この中からパブリックIPv4 DNSの部分のURLをブラウザで表示します。「オープンアドレス」の部分のリンクをクリックすることで別タブで表示されます。
    ![get ec2 url](/images/aws_publish_apache/aws_publish_apache_tutorial_04.jpg)

1. ブラウザで表示してみる
    現時点の設定ではインターネットからのアクセスを許可していないのでエラー画面が表示されます。
    ![occur error](/images/aws_publish_apache/aws_publish_apache_tutorial_05.jpg)

1. セキュリティグループの設定を表示する
    インターネットからの接続を許可するためにセキュリティグループの設定を変更します。
    インスタンス詳細のタブから「セキュリティ」を選択し、セキュリティグループのリンクを押します。下図のスクリーンショットでは「sg-04a06dc0bdc77cfd6 (launch-wizard-1)」の部分です。
    ![show security group](/images/aws_publish_apache/aws_publish_apache_tutorial_06.jpg)

1. インバウンドルールの編集を始める
    セキュリティグループ画面に遷移するので「インバウンドのルールを編集」ボタンを押します。
    ![start apache](/images/aws_publish_apache/aws_publish_apache_tutorial_07.jpg)

1. インバウンドルールの追加を始める
    画面がインバウンドルール編集状態になるので「ルールを追加」ボタンを押します。
    ![start apache](/images/aws_publish_apache/aws_publish_apache_tutorial_08.jpg)

1. 追加するインバウンドルールを設定する
    以下の設定を行って「ルールを保存」ボタンを押します。
    ・タイプ:  HTTP
    ・ソース： Anyware-IPv4
    ![start apache](/images/aws_publish_apache/aws_publish_apache_tutorial_09.jpg)

1. 追加したインバウンドルールを確認する
    セキュリティグループのインバウンドの設定が変わったことを確認します。
    ![start apache](/images/aws_publish_apache/aws_publish_apache_tutorial_10.jpg)

1. ブラウザで表示する
    ブラウザでEC2のURLを再度表示するとApacheの初期画面が表示できます。
    ![get ec2 url](/images/aws_publish_apache/aws_publish_apache_tutorial_11.jpg)

# 次はこれをやろう
1. EC2とRDSでWordPressを動かしてみる(鋭意作成中)

AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。
