---
title: "AWS CLIでS3を操作する - AWSをはじめからていねいに"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "S3", "初心者"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。

# 概要
AWS CLIのインストールと設定を行ってAWS操作をコマンドラインで行えるようになります。
この記事ではS3の操作を行います。

# ゴール
AWS CLIでS3バケットの作成と表示を行う。
![Goal](/images/aws_biginner_use_cli/aws_biginner_use_cli_goal.jpg)

# 必要なもの
- 作業時間：15分
- 費用：無料
- 「アクセスキー・プログラムによるアクセス」が可能なIAMユーザー
:::message
「アクセスキー・プログラムによるアクセス」が可能なIAMユーザーが存在しない場合は「[普段使いのIAMユーザーを作る](https://zenn.dev/sway/articles/aws_biginner_create_iam_user)」の手順を参考に作ってください。
:::

# 登場する主なコンポーネント

1. AWS CLI
    AWS操作をコマンドラインで行うためのツールです。
    AWSに慣れてくるとコンソールを立ち上げての操作が面倒になったり、AWS操作をプログラムで行ったりするようになります。このような場合に使用するのがAWS CLIです。
    私が最もよく使用するのがS3へのファイルアップロードとダウンロードです。以下のようなコマンドでフォルダの同期が行えるのでとても楽です。
    ```
    aws s3 sync ./ s3_bucket_name
    ```

1. S3
    AWSのストレージサービスです。容量無制限でデータの紛失リスクが極めて少ないのが特徴です。
    S3はバケットという入れ物を定義して、バケットごとに異なる設定ができます。

# AWS CLIを使うための手順

1. AWS CLIをダウンロードする
    [AWS CLIの説明ページ](https://aws.amazon.com/jp/cli/)の画面右側からお使いの環境に応じてダウンロードしてください。
    @[card](https://aws.amazon.com/jp/cli/)
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_01.jpg)

1. AWS CLIのインストールする
    インストールは全てデフォルト設定で問題ありません。
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_02.jpg)
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_03.jpg)
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_04.jpg)
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_05.jpg)
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_06.jpg)
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_07.jpg)

1. AWS CLIが使用できることを確認する
    コマンドプロンプトを起動して「aws」コマンドを実行し、使い方の説明が表示されることを確認します。
    ```
    aws
    ```
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_08.jpg)

1. AWS CLIの設定を開始する
    AWS CLIの設定を行うための「aws configure」を実行します。
    ```
    aws configure
    ```
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_09.jpg)

1. アクセスキーとシークレットキーを設定する
    アクセスキーとシークレットキーを設定します。
    :::message
    アクセスキーとシークレットキーを忘れてしまった場合は再発行ができます。マネジメントコンソールのIAMユーザーの設定から行います。
    :::
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_10.jpg)

1. デフォルトリージョンを東京に設定する
    AWS CLIでAWSの操作を行う際はパラメーターでリージョンを指定します。毎回指定するのは面倒なのでデフォルトのリージョンを定義しておくことで指定しなくてすむようにできます。
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_11.jpg)

1. 出力形式をデフォルトに設定する
    AWS CLIはコマンド出力形式をoutputパラメーターで指定することができます。無指定の場合はテキストとなります。
    出力を目で確認する場合はテキストが見やすいのでデフォルトのままで進めます。
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_12.jpg)

1. S3バケットの作成
    AWS CLIの設定が完了したらAWS CLIでS3バケットを作成します。S3バケットを作成するためのコマンドは以下の通りです。mbはmake bucketの略と思われます。*bucket_name*には全世界でユニークなバケット名を指定する必要があります。
    ```sh
    aws s3 mb bucket_name
    ```
    :::message
    バケット名は全世界（あなた以外のAWS利用者も含めた全員）でユニークな値が必要です。testなどの簡易な名前は使われているためエラーとなります。
    :::
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_13.jpg)

1. S3バケットを一覧表示する
    S3バケットができたら表示して確認します。S3バケットの一覧を表示するためのコマンドは以下の通りです。lsはUNIX系OSで一覧表示するためのコマンドでlist segmentsの略です。
    ```
    aws s3 ls
    ```
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_14.jpg)

1. マネジメントコンソールでS3ダッシュボードを表示する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「ストレージ」を選択します。表示されるサブメニューから「S3」を選択します。
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_15.jpg)

1. 作成したS3バケットが一覧に表示されていることを確認する
    S3ダッシュボードのバケット一覧に作成したバケットが含まれていること確認します。
    ![select iam from menu](/images/aws_biginner_use_cli/aws_biginner_use_cli_tutorial_16.jpg)

# 次はこれをやろう
- AWS CLIでセッションマネージャー接続する(鋭意作成中)
