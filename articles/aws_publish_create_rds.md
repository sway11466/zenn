---
title: "RDSでデータベースを構築する - AWSをはじめからていねいに"
emoji: "📒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "RDS", "初心者"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
[AWS記事の一覧](https://zenn.dev/sway/articles/aws_index_list)

# 概要
MySQLデータベースをAWSのマネージドなデータベースサービスであるRDSを使って構築します。
構築したMySQLにはEC2から接続します。接続するためのセキュリティグループの設定も行います。

# ゴール
EC2からMySQLに接続してデータベースの一覧を表示します。
![Goal](/images/aws_publish_create_rds/aws_publish_create_rds_goal.jpg)

# 必要なもの
- 作業時間：30分
- 費用：無料※
    :::message
    EC2とRDSの無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は10円ぐらいかかります。
    :::
- AWSアカウント
- EC2
    RDSへの接続に使用します。構築していない場合は「[とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)」を参考に構築してください。
    OSはAmazonLinux2を使っています。

# 登場する主なコンポーネント

1. RDS
    AWSのマネージドなリレーショナルデータベースす。ハードウェアを気にすることなくデータベースを構築することができます。

1. セキュリティグループ
    AWSコンポーネントのファイアーウォールです。今回の記事ではデータベースに接続可能なのはEC2のみに制限します。

# RDSの作成手順

1. RDSダッシュボードを表示する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「データベース」を選択します。表示されるサブメニューから「RDS」を選択します。
    ![select rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_01.jpg)

1. データベースの作成を開始する
    「データベースの作成」ボタンを押してデータベースの作成を開始します。
    ![start create rds](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_02.jpg)

1. データベースの設定を入力する①
    「データベース作成方法を選択」は「簡単に作成」を選択します。「設定」は「MySQL」を選択します。「DBインスタンスサイズ」は「無料利用枠」を選択します。
    ![setting rds 1](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_03.jpg)

1. データベースの設定を入力する②
    「DBインスタンス識別子」「マスターユーザー名」「マスターパスワード」は自由に設定します。
    「DBインスタンス識別子」は構築するMySQLの名前のようなものです。今回は練習用なので「mysql」などを入れておけばよいでしょう。
    「マスターユーザー名」と「マスターパスワード」は構築するMySQLであらゆる権限を持つ特権ユーザーとなります。「マスターユーザー名」は慣例である「admin」で構いませんが「パスワード」は推測されにくい値を設定するようにしましょう。ここで指定した「マスターユーザー名」と「マスターパスワード」は後ほどEC2からの接続に使用するため覚えておきます。
    入力したら「データベースの作成」ボタンを押します。
    ![setting rds 2](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_04.jpg)

1. データベースが作成されるのを待ちます
    データベース一覧に切り替わりデータベース作成中の状態になるので、作成が完了するまで待ちます。
    ![wait rds creating](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_05.jpg)

1. 作成されたデータベースの詳細を確認します
    データベースの作成が完了したらデータベース名のリンク（以下のスクリーンショットではmysql）を押します。
    ![check rds created](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_06.jpg)

1. MySQLのエンドポイントを覚えてセキュリティグループの設定を始めます
    EC2からの接続に使用する「エンドポイント」を覚えておきます。
    つぎに「接続とセキュリティ」タブの「セキュリティ」の「VPCセキュリティグループ」項目の下のリンクを押します。（以下ののスクリーンショットでは「sg-0ea6476d34f6d6715」の部分です。）
    ![show rds endpoint](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_07.jpg)

1. インバウンドルールを表示します
    セキュリティグループ編集画面が表示されるので、画面下部のタブから「インバウンドルール」を選択します。
    ![show inbound](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_08.jpg)

1. インバウンドルールの設定変更を始めます
    「インバウンドのルールを編集」ボタンを押します。
    ![change inbound](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_09.jpg)

1. インバウンドルールに新しいルールを追加します
    左下の「ルールを追加」ボタンを押します。
    ![add inbound rule](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_10.jpg)

1. 新しいルールの設定を入力します
    新しいルールの行が追加されます。
    「タイプ」に「MYSQL/Aurora」を設定し、「ソース」にEC2の属するセキュリティグループを設定します。
    入力が終わったら「ルールを保存」ボタンを押します。
    ![add inbound rule](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_11.jpg)

1. インバウンドルールが増えたことを確認します
    セキュリティグループのインバウンドタブに入力したルールが追加されていることを確認します。
    これでセキュリティグループの設定は完了です。
    ![check inbound rule](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_12.jpg)

1. EC2にセッションマネージャーで接続する
    EC2にセッションマネージャーで接続します。セッションマネージャーでの接続方法がわからない場合は「[とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)」の「手順20. EC2に接続する」を確認してください。

1. EC2にMySQLインストール用のリポジトリを追加する
    AmazonLinux2にはMySQLのリポジトリが登録されていません。このため以下のコマンドでMySQLのリポジトリを追加します。
    ```sh
    sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm -y
    ```
    ![add mysql repository](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_13.jpg)

1. EC2にMySQL接続するためのクライアントをインストールする
    MySQL接続のためのクライアントをインストールするために以下のコマンドを実行します。
    ```sh
    sudo yum install -y mysql-community-client
    ```
    ![install mysql client](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_14.jpg)

1. RDSに接続する
    MySQL接続のコマンドを使用してMySQLに接続します。*hostname*には7項で覚えた「エンドポイント」を、*username*には「マスターユーザー名」を指定します。
    コマンド実行後にパスワードを聞かれるので「マスターパスワード」を入力します。
    ```
    mysql -h hostname -u username -p
    ```
    ![connect mysql](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_15.jpg)

1. MySQLのデータベース一覧を表示する
    MySQLのデータベース一覧を表示するクエリ「show databeses;」を実行します。
    ```sql
    show databases;
    ```
    ![show databases](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_16.jpg)

1. MySQL接続を終了する
    MySQL接続を終わるために「exit」コマンドを入力します。
    ```
    exit
    ```
    ![disconnect mysql](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_17.jpg)

1. セッションマネージャーを終了する
    セッションマネージャーを終わるために「exit」コマンドを入力します。
    ```
    exit
    ```
    ![exit session manager](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_18.jpg)

1. EC2を停止する
    確認が終わったのでEC2を停止します。停止の手順がわからない場合は「[とにかくEC2を立ててログインする](https://zenn.dev/sway/articles/aws_biginner_create_ec2)」の26項を参考にして終了させてください。

1. MySQLの停止を始める
    確認が終わったのでMySQLを停止します。
    RDSメニューの「データベース」を選択し、停止する「mysql」データベースの左側のラジオボタンを選択して「アクション」から「停止」を選択します。
    ![install mysql client](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_19.jpg)

1. RDSを停止する
    DBインスタンスの停止の確認ダイアログが表示されます。
    スナップショットの作成は「なし」を選択し、「はい、今すぐ停止します」ボタンを押します。スナップショットとはバックアップのことです。今回の手順ではデータベースにデータを入れていないのでバックアップは不要です。
    ![install mysql client](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_20.jpg)

1. RDSの一覧でMySQLが停止するのを待ちます
    データベース一覧の「mysql」のステータスが「停止済」になったら停止の完了です。
    ![install mysql client](/images/aws_publish_create_rds/aws_publish_create_rds_tutorial_21.jpg)

# 感想
個人的にはRDSならAurora一択なのですが（記事を作成予定）、残念なことに無料枠が準備されていません。
初心者向けのAWS記事で有料サービスを使用するのはハードルが高いと考えて無料枠のあるRDSにしました。
Auroraの無料枠作ってくれないかな。。。

# 次はこれをやろう
- EC2とRDSでWordPressを動かしてみる(鋭意作成中)
