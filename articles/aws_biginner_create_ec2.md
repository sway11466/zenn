---
title: "とにかくEC2を立ててログインする - AWSをはじめからていねいに"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "EC2", "セッションマネージャー", "初心者"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。

# 概要
マネジメントコンソールでEC2を構築してセッションマネージャーで接続します。
セッションマネージャーを使うために専用のIAMロールを作成してEC2に割り当てる必要があります。
この記事では以下の順番で操作を行います。
1. IAMロールの作成
1. EC2の作成
1. セッションマネージャーで接続

# ゴール
EC2にセッションマネージャーで接続してechoコマンドでhello worldを表示します。地味。。。
![Goal](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_goal.jpg)

# 必要なもの
- 作業時間：30分
- 費用：無料※
    :::message
    EC2の無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は5円ぐらいかかります。
    :::
- AWSアカウント

# 登場する主なコンポーネント

1. EC2
    AWSの仮想サーバーです。課金が秒単位のため必要なときだけ起動して使い終わったら停止することで費用を節約することができます。
1. セッションマネージャー
    ブラウザ上でEC2に接続して操作を行うための機能です。2019年9月に登場しました。
    この機能が登場するまではEC2サーバー上でSSHサービスを起動してSSHで接続するのが一般的でした。初心者にはハードルが高く、接続するための鍵情報の管理などで多くの問題がありました。
    セッションマネージャーの登場でEC2への接続の難易度は大幅に下がりました。
1. IAMロールとIAMポリシー
    EC2にセッションマネージャーで接続するためには専用の権限をつける必要があります。
    権限のことをAWSではIAMポリシーと呼びます。IAMポリシーには多くの種類が存在しますが、今回はセッションマネージャーを使うための権限をEC2に与えます。
    EC2にIAMポリシーを直接与えることはできないので、IAMロールを使ってEC2に割り当てます。
    図にすると以下のようなイメージとなります。
    ![IAMRole IAMPolicy](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_iam_description.jpg)
    ただし、上記の説明は正確ではありません。IAM権限は理解が難しく、とりあえずEC2を動かすレベルであれば上記の理解で問題ないでしょう。IAMについて詳しく知りたい場合は専用の記事を書く予定なのでそちらを参照してください。

# EC2の作成手順

1. リージョンを東京に変更する
    マネジメントコンソールにログインしたら右上のリージョンを確認してください。東京になっていない場合は東京に変更します。
    「アジアパシフィック(東京)」を選択すると東京リージョンに変わります。
    ![select tokyo region](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_01.jpg)

1. マネジメントコンソールからIAMサービスを選択する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「セキュリティ、ID、およびコンプライアンス」を選択します。表示されるサブメニューから「IAM」を選択します。
    ![select iam from menu](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_02.jpg)

1. IAMロール一覧を表示する
    IAMダッシュボード左側のメニューから「ロール」を選択してロール一覧を表示します。
    ![select iamrole from dashbord](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_03.jpg)

1. IAMロールの作成を開始する
    「ロールを作成」ボタンを押してIAMロールの作成をはじめます。
    ![create iamrole](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_04.jpg)

1. EC2用のロールとして作成する
    「ユースケースの選択」から「EC2」を選択して「次のステップ：アクセス権限」ボタンを押します。
    ![select assume role](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_05.jpg)

1. セッションマネージャー用のポリシーを選ぶ
    「ポリシーのフィルタ」に「AmazonSSMManagedInstanceCore」を入力して絞り込みます。
    表示されたポリシーのチェックボックスをチェックして「次のステップ：タグ」ボタンを押します。
    ![select policy](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_06.jpg)

1. タグの作成はスキップする
    タグの追加画面が表示されますが、必須ではないのでスキップして「次のステップ：確認」ボタンを押します。
    ![skip tag](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_07.jpg)

1. ロールに名前をつける
    「ロール名」に「SessionManagerRole」を入力し「ロールの作成」ボタンを押します。
    ![name iamrole](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_08.jpg)

1. 一覧に作成したロールがあることを確認する
    これでIAMロールの作成は完了です。
    ![check iamrole list](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_09.jpg)

1. EC2ダッシュボードを表示する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「コンピューティング」を選択します。表示されるサブメニューから「EC2」を選択します。
    ![show EC2 dashbord](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_10.jpg)

1. EC2インスタンス一覧んを表示する
    EC2ダッシュボード左側のメニューから「インスタンス」を選択してインスタンス一覧を表示します。
    ![show EC2 list](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_11.jpg)

1. EC2の作成を開始する
    右上の「インスタンスを起動」ボタンを押してEC2の作成をはじめます。
    ![start create ec2](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_12.jpg)

1. マシンイメージにAmazon Linux 2 AMIを選択する
    マシンイメージの一覧から「Amazon Linux 2 AIM」を選択します。
    「Amazon Linux 2 AIM」が複数表示されている場合、リストの一番上に表示されている最新バージョンを選択します。
    ![select amazon linux2](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_13.jpg)

1. インスタンスタイプに無料枠対象のt2.microを選択する
    インスタンスタイプの一覧から「t2.micro」を選択して「次のステップ：インスタンス詳細の設定」ボタンを押します。
    ![select instance type](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_14.jpg)

1. IAMロールにSessionManagerRoleを設定する
    IAMロールに「SessionManagerRole」を設定して「確認と作成」ボタンを押します。
    ![select iamrole](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_15.jpg)

1. 構成を確認する
    AMIが「Amazon Linux 2 AIM」になっていること、インスタンスタイプが「t2.micro」であることを確認して「起動」ボタンを押します。
    :::message
    「インスタンスのセキュリティを強化してください。 セキュリティグループ launch-wizard-1 は世界に向けて開かれています。」というメッセージが心配になる方も多いと思います。
    このメッセージの通り、このサーバーは全世界に公開されてSSHというサーバー接続用のサービスのポートが利用可能な状態で構築します。
    しかし、起動したEC2サーバーでSSHのサービスを起動しないため、全世界のユーザーが接続して操作を行うことはできません。
    心配な気持ちを抑えて、このまま先に進みましょう。
    :::
    ![confirm ec2 create](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_16.jpg)

1. キーペアは作成せずにEC2を作成する
    キーペアの使用に関するダイアログが表示されます。
    「キーペアなしで続行」を選択し「私は、キーペアがない場合・・・」のチェックボックスをチェックして「インスタンスの作成」ボタンを押します。
    :::message
    ちゃんとEC2に接続できるか心配になるメッセージが表示されていますが、キーペアはSSH接続を行う場合に必要となるものです。今回の手順ではSSHは使用せずにセッションマネージャーで接続するためキーペアの作成は不要です。
    心配な気持ちを抑えて、このまま先に進みましょう。
    :::
    ![select key pair](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_17.jpg)

1. インスタンスの作成が開始されたことを確認する
    「インスタンスは現在作成中です」が表示されていることを確認して「インスタンスの表示」ボタンを押します。
    ![check ec2 status](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_18.jpg)

1. 一覧に作成したEC2があることを確認する
    EC2の一覧に追加された行のインスタンスの状態が「実行中」になっていることを確認します。
    ![check ec2 list](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_19.jpg)

1. EC2に接続する
    EC2の一覧の左側のチェックボックスをチェックして「接続」ボタンを押します。
    ![connect ec2](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_20.jpg)

1. 接続方法にセッションマネージャーを選択する
    「セッションマネージャー」を選択して「接続」ボタンをおします。
    ![select connection way](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_21.jpg)

1. セッションマネージャーでコマンドを実行する
    別タブでコンソール画面が表示されます。（起動するまではAWSコンソールの画面で処理が行われます）
    ここで「echo hello world!」コマンドを入力してみましょう。
    以下画面のようにhello world!が表示されれば正常に接続できています。
    ![exec command](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_22.jpg)

1. セッションマネージャーを終了する
    「exit」コマンドを入力してセッションマネージャーを終了します。
    ![exit session manager](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_23.jpg)

1. 終了確認ダイアログを閉じる
    終了確認ダイアログが表示されるので「閉じる」ボタンを押します。
    ![hide exit dialog](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_24.jpg)

1. EC2一覧を表示する
    接続画面に戻るのでパンくずリストの「インスタンス」を選択してEC2一覧を表示します。
    ![show ec2 list](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_25.jpg)

1. 作成したEC2を停止する
    EC2の一覧の左側のチェックボックスをチェックして「インスタンスの状態」プルダウンから「インスタンスを停止」を選択します。
    ![stop ec2](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_26.jpg)

1. 確認ダイアログで停止を押す
    確認ダイアログが表示されるので「停止」ボタンを押します。
    ![confirm dialog](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_27.jpg)

1. 一覧の表示が停止中になったことを確認する
    EC2の一覧のインスタンスの状態が「停止中」となったことを確認します。
    しばらくすると「停止済み」に自動的に変わります。
    ![check ec2 status](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_28.jpg)

1. 一覧の表示が停止済みになったことを確認する
    EC2の一覧のインスタンスの状態が「停止済み」となったことを確認します。
    停止中のインスタンスは課金されません。
    ![check ec2 status](/images/aws_biginner_create_ec2/aws_biginner_create_ec2_tutorial_29.jpg)

# 感想
セッションマネージャーの登場でEC2の構築や操作が格段に楽になりました。
セッションマネージャーの登場でSSH接続することは少なくなっていると思うので、EC2作成時のキーペアの確認は表示しないほうが初心者を不安にさせなくて良いと思いますね。

# 次はこれをやろう
- [AWS CLIでS3を操作する](https://zenn.dev/sway/articles/aws_biginner_use_cli)
- [RDSでデータベースを構築する](https://zenn.dev/sway/articles/aws_publish_create_rds)

AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。
