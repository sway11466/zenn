---
title: "EC2とRDSでWordPressを動かしてみる - AWSをはじめからていねいに"
emoji: "📒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "Apache", "RDS", "WordPress"]
published: false
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。

# 概要
EC2にWordPressを導入する記事はたくさんあるのですが、RDSを使っているケースはあまり見当たらないようです。EC2のみで構築すると簡単そうに思えるのですが、実際に運用を始めるとバックアップの管理が面倒だったりするなどの手間が出てきます。RDSで作っておくと運用が楽になるので最初からRDSで構築しておくのがよいでしょう。

# ゴール
EC2とRDSでWordPressを動かす。
![image title](/images/aws_publish_wordpress/aws_publish_wordpress_goal.jpg)

# 必要なもの
- 作業時間：60分
- 構築にかかる費用：無料※
- 運用にかかる費用：無料※
    :::message
    EC2とRDSの無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は構築費で10円ぐらい、毎月5000円ぐらいかかります。
    [参考見積はこちら](https://calculator.aws/#/estimate?id=8d4e89ac81c0191bde443b20c3171d3af40c88ae)
    :::
- ApacheをインストールしたEC2
- MySQLのRDS
    :::message
    ApacheやRSDを準備していない場合は以下の記事を参考にして構築しましょう。
    - [EC2にApacheをインストールしてブラウザで表示する](https://zenn.dev/sway/articles/aws_publish_apache)
    - [RDSでデータベースを構築する](https://zenn.dev/sway/articles/aws_publish_create_rds)
    :::

# EC2とRDSでWordPressを動かしてみる

## PHPをインストールする
Wordpressを実行するためのPHPをインストールします。

1. PHPのリポジトリを設定する
    amazon-linux-extras コマンドでインストールに使うリポジトリを指定します。
    ```
    sudo amazon-linux-extras enable php7.4
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_01.jpg)

1. PHPをインストールする
    yumコマンドでphpをインストールします。
    ```
    sudo yum install php php-gd php-mysqlnd php-xmlrpc -y
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_02.jpg)

1. PHPがインストールされたことを確認する
    phpコマンドでバージョンを表示してインストールが正常に行われていることを確認します。
    ```
    php -version
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_03.jpg)

## WordPressをインストールする

1. 作業ディレクトリを変更する
    セッションマネージャーで接続している場合はカレントディレクトリが /usr/bin になっているのでホームディレクトリに変更します。
    Linuxでは ~（チルダ） がホームディレクトリを表します。
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_04.jpg)

1. WordPressをダウンロードする
    curlコマンドでwordpressをダウンロードします。
    ダウンロードしたファイルがあることをlsコマンドで確認します。
    ```
    wget https://wordpress.org/latest.tar.gz
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_05.jpg)

1. ダウンロードしたファイルを解凍する
    tarコマンドでダウンロードしたファイルを解凍します。
    ```
    tar -xzvf latest.tar.gz
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_06.jpg)

1. 設定ファイルのサンプルをコピーする
    解凍ファイルに含まれているサンプルの設定ファイルをコピーします。
    ```
    cp wordpress/wp-config-sample.php wordpress/wp-config.php
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_07.jpg)

1. nanoエディタで設定ファイルの編集を始める
    nanoエディタを使用して設定ファイルの変更を始めます。
    ```
    nano wordpress/wp-config.php
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_08.jpg)

1. DB設定を変更する
    DBの以下4つの設定を変更します。DB_NAMEは任意の値を設定して構いませんが、この手順では「wordpress-db」を使用します。
    マスターユーザー名、マスターパスワード、エンドポイントはRDS構築時に指定した値です。
    | 設定名       | 設定する値                                   |
    |-------------|---------------------------------------------|
    | DB_NAME     | wordpress-db                                |
    | DB_USER     | RDSのインストール時に指定したマスターユーザー名 |
    | DB_PASSWORD | RDSのインストール時に指定したマスターパスワード |
    | DB_HOST     | RDSのエンドポイント                          |
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_09.jpg)

1. 変更を保存してnanoエディタを終了する
    キーボード操作で「C-o」（コントロールキーを押したままo）を押すとファイル保存モードになるので、エンターキーを押して保存します。
    次に「C-x」（コントロールキーを押したままx）を押すとエディタが終了します。

1. WordPressのファイルをApacheの配下にコピーする
    copyコマンドでWordPressのファイルをApacheの配下にコピーします。
    ```
    cp -r wordpress/* /var/www/html/
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_10.jpg)

## Apacheの設定をWordPress用に変更する

1. nanoエディタで設定ファイルの編集を始める
    WordPressのパーマリンクを使用するにはApacheの.htaccess設定を有効にする必要があります。Amazon Linux2 ではデフォルトでは無効になっているので有効に変更します。
    nanoエディタを使用して設定ファイルの変更を始めます。
    ```
    sudo nano /etc/httpd/conf/httpd.conf
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_11.jpg)

1. .htaccessを有効にする
    設定ファイルから <Directory "/var/www/html"> という行を探し、その後にある「AllowOverride」の値を None から All に変更します。
    :::message
    この設定ファイルにはAllowOverrideという項目が何度か登場します。以下のスクショでも２か所存在しています。編集するのは<Directory "/var/www/html">タグの中のAllowOverrideの値なので間違わないように注意しましょう。
    :::
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_12.jpg)

1. 変更を保存してnanoエディタを終了する
    キーボード操作で「C-o」（コントロールキーを押したままo）を押すとファイル保存モードになるので、エンターキーを押して保存します。
    次に「C-x」（コントロールキーを押したままx）を押すとエディタが終了します。

1. Apacheによる書き込み権限を追加する
    WordPressはドキュメントルート（/var/www/html）の書き込み権限が必要となります。
    WordPressを実行するApacheユーザーに一連の権限を設定します。
    ```
    sudo chown -R apache /var/www
    sudo chgrp -R apache /var/www
    sudo chmod 2775 /var/www
    find /var/www -type d -exec sudo chmod 2775 {} \;
    find /var/www -type f -exec sudo chmod 0664 {} \;
    ```
    :::message
    4つめと5つめのfindコマンドによる処理は数十秒程度の処理時間が必要です。気長に待ちましょう。
    :::
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_13.jpg)

1. 変更した設定を有効にするためApacheを再起動する
    systemctlコマンドでApacheを再起動して変更した設定を有効にします。
    ```
    sudo systemctl restart httpd
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_14.jpg)

## WordPress用のDBを作成する

1. DBに接続する
    mysqlコマンドでDBに接続します。
    :::message
    DB接続方法がわからない場合は[RDSでデータベースを構築する](https://zenn.dev/sway/articles/aws_publish_create_rds)を参照して接続してください。
    :::
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_15.jpg)

1. WordPress用DBを作成する
    WordPressの設定ファイルのDB_NAMEに指定したDBを作成します。この手順の通りに作業していれば「wordpress-db」が設定されています。
    DBの作成にはCREATE DATABASEコマンドを使用します。
    ```
    CREATE DATABASE `wordpress-db`;
    ```
    DBが作成されたことの確認はshow databaseseコマンドで行います。
    ```
    show databases;
    ```
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_16.jpg)

1. DB接続を終わります
    exitコマンドでDB接続を終わります。

## ブラウザでWordPressを表示する

1. ブラウザでWordPress画面を表示する
    ブラウザでEC2にインストールしたWordPress画面を表示します。以下のスクショのように言語選択画面が表示されればインストールは正常に終了しています。
    :::message
    表示方法がわからない場合は[EC2にApacheをインストールしてブラウザで表示する](https://zenn.dev/sway/articles/aws_publish_apache)を参照して表示してください。
    :::
    ![image title](/images/aws_publish_wordpress/aws_publish_wordpress_tutorial_17.jpg)

# 感想
AWSの構築記事を書くにあたって、お手軽に動かせるソフトウェアにWordPressを使おうと考えて書いた記事です。
実のところWordPressを使ったことがなく、名前だけ知っているという状態でした。こういうSIerさん多いんじゃないかなと思います。

# 次はこれをやろう
- 独自ドメイン名をつけてRoute53で管理する(鋭意作成中)

AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。
