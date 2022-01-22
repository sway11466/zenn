---
title: "独自ドメイン名でサーバーを公開する - AWSをはじめからていねいに"
emoji: "📒"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "Route53", "独自ドメイン"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。
AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。

# 概要
EC2に構築したWordPressを独自ドメインで公開します。
Route53での以下設定を行います。
- ドメインの取得
- ドメインへのEC2の割り当て

# ゴール
取得したドメイン名でWordPress画面を表示する。
![image title](/images/aws_publish_original_domain/aws_publish_original_domain_goal.jpg)

# 必要なもの
- 作業時間：60分
- 構築にかかる費用：1000円～
    :::message
    ドメイン名の取得に費用が発生します。ドメインの種類によって金額は異なりますが、comドメインの場合は年間1500円程度かかります。
    :::
- 運用にかかる費用：1000円～／年
    :::message
    EC2とRDSは無料枠の使用を想定しています。AWSアカウント作成から12カ月以内の場合は無料です。無料枠がない場合は構築費で10円ぐらい、毎月5000円ぐらいかかります。
    これとは別に、ドメイン維持とRoute53に費用が必要となります。
    [参考見積はこちら（注：ドメイン維持費用を含んでいません）](https://calculator.aws/#/estimate?id=c92163a82fef05c3da2a7ed365e44b00c14474af)
    :::
- WordPressが動作しているEC2
    :::message
    WordPressを準備していない場合は以下の記事を参考にして構築しましょう。
    - [EC2とRDSでWordPressを動かしてみる](https://zenn.dev/sway/articles/aws_publish_wordpress)
    :::

# 登場する主なコンポーネント

1. Route53
    AWSのフルマネージドなDNSサービスです。SLA100%を誇るサービスです。すごい。

1. ホストゾーン
    Route53で管理する１つのドメインをホストゾーンと呼びます。Route53でドメインを取得するとホストゾーンが自動作成されます。

# ドメイン名の取得とEC2の割り当て手順

## ドメイン名を取得する

1. Route53ダッシュボードを表示する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「ネットワーキングとコンテンツ管理」を選択します。表示されるサブメニューから「Route 53」を選択します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_01.jpg)

1. ドメイン一覧を表示する
    ダッシュボードの左側のメニューから「取得済みドメイン」を選択します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_02.jpg)

1. 新規ドメイン取得を開始する
    「ドメインの登録」ボタンを押してドメインの取得を始めます。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_03.jpg)

1. ドメイン名を入力する
    取得したいドメイン名を入力して「チェック」ボタンを押します。
    トップレベルのドメインは入力不要です。たとえば sway11466.com を取得したい場合は sway11466 のみを入力します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_04.jpg)

1. ドメイン名をカートに入れる
    取得したいドメイン名の右側にある「カートに入れる」ボタンを押します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_05.jpg)

1. ドメインの購入手続きに進む
    画面右下の「続行」ボタンを押してドメインの購入手続きに進みます。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_06.jpg)

1. ドメイン購入者の情報を入力します
    ドメイン購入者の情報を入力して「続行」ボタンを押します。プライバシー保護を有効化することで入力した情報が非表示になり、WHOISに公開されるのはAWSの情報のみになります。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_07.jpg)

1. Eメール認証の説明を確認して進みます
    登録したメールアドレスの認証が15日以内に必要となる旨の説明が表示されるので「同意します」ボタンを押します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_08.jpg)

1. Eメール認証を行う
    「同意します」ボタンを押すと以下のようなメールが届きます。このメールのリンクを押してメールアドレス認証を行います。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_09.jpg)

1. Eメール認証結果を確認する
    メールのリンクを押すと以下のような画面に変わってメール認証は完了です。AWSコンソールに戻って次の操作に進みます。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_10.jpg)

1. Eメール認証のステータスを更新する
    連絡先の詳細の確認の「登録者の連絡先のEメールアドレスの確認」の「ステータスの更新」ボタンを押して認証の状況を更新します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_11.jpg)

1. ドメイン購入手続きを完了する
    「注文を完了」ボタンを押してドメインを購入します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_12.jpg)

1. 注文完了を確認する
    注文が完了した旨のダイアログが表示されます。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_13.jpg)

1. ドメインの登録状況を確認する
    ダッシュボードの左側のメニューから「保留中のリクエスト」を選択します。先ほど注文したドメインが保留中になっていますので登録されるまで待ちます。私が行ったときは5分ほどで登録されました。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_14.jpg)

1. ドメインが登録されたことを確認する
    ダッシュボードの左側のメニューから「登録済のドメイン」を選択します。先ほど購入したドメインが登録されていることを確認します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_15.jpg)

## EC2のIPアドレスを確認する
購入したドメインに割り当てるEC2のIPアドレスを調べます。

1. インスタンスの一覧を表示する
    EC2ダッシュボードの左側のメニューから「インスタンス」を選択します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_16.jpg)

1. ドメインに割り当てるEC2を選ぶ
    インスタンスの一覧から取得したドメイン名に割り当てるEC2を選択します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_17.jpg)

1. パブリックIPv4アドレスを確認する
    画面下部のインスタンス情報から「パブリックIPv4アドレス」の値を確認します。以下のスクリーンショットでは「54.95.145.96」となっています。
    この値をRoute53に登録するので覚えておきます。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_18.jpg)

## Aレコードを登録する

1. 対象のドメインを選択する
    Route53ダッシュボードの左側のメニューから「ホストゾーン」を選んでドメインの一覧を表示し、ドメイン名を選択して「編集」ボタンを押します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_19.jpg)

1. レコードの作成を開始する
    「レコードの作成」ボタンを押します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_20.jpg)

1. レコード情報を入力する
    以下の通りレコード情報を入力して「レコードを作成」ボタンを押します。
    | 項目名         | 入力する値                             |
    |----------------|--------------------------------------|
    | レコードタイプ  | A - IPv4アドレスと一部のAWSリソースに…  |
    | 値             | 公開したいEC2のパブリックIPv4アドレス    |
    上記以外の項目はデフォルト値のままで進めます。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_22.jpg)

1. 登録したレコード情報を確認する
    レコード情報が意図した内容となっているか確認します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_23.jpg)

## ブラウザでドメインを表示する

1. ドメイン名でアクセスできることを確認する
    ブラウザに取得したドメイン名を入力してWordPress画面が表示できることを確認します。
    ![image title](/images/aws_publish_original_domain/aws_publish_original_domain_tutorial_24.jpg)

# 注意点
この手順を行うとドメイン名でEC2にインストールしたWordPressを表示できるようになります。
しかし、EC2の再起動を行うとアクセスできなくなってしまうはずです。これは、EC2は再起動するごとにグローバルIPv4アドレスが変わってしまうためです。
このため、以下などの対応を行うことになりますが、これらは別の記事で説明します。
- グローバルIPアドレスが変わるたびにAレコードの値を変更する
- ElasticIPを使用してグローバルIPアドレスを固定する
- ALBを使用してEC2以外をドメインに割り当てる

# 次はこれをやろう
1. ALB配下でEC2を動かす(鋭意作成中)

AWS関連の他の記事は[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)からどうぞ。
