ｎ---
title: "普段使いのIAMユーザーを作る - AWSをはじめからていねいに"
emoji: "🐣"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["AWS", "IAM", "初心者"]
published: true
---
ていねいを心掛けたAWS記事です。スクリーンショット満載でやった気になれます。

# 概要
AWSアカウントを作成するとルートユーザーでログインできるようになります。
ルートユーザーは全ての権限をもつ特別なユーザーなので日常的には使用しません。
日常的に使用するIAMユーザーを作成して使うようにしましょう。
この手順で作成するIAMユーザーは必要最低限の設定のみです。

# ゴール
IAMユーザーでログインしてマネジメントコンソールを表示する。

# 必要なもの
- 作業時間：15分
- 費用：無料
- AWSアカウント

# IAMユーザーの作成手順

1. マネジメントコンソールからIAMサービスを選択する
    マネジメントコンソールの左上の「サービス」を押すと表示されるメニューから「セキュリティ、ID、およびコンプライアンス」を選択します。表示されるサブメニューから「IAM」を選択します。
    ![select iam from menu](/images/aws_biginner_create_iam_user01.jpg)
    ![select iam from menu](/images/aws_biginner_create_iam_user01b.jpg)

2. IAMダッシュボードからユーザーを選択する
    IAMダッシュボードの左側のメニューから「▼ アクセス管理」グループの「ユーザー」を選択します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user02.jpg)

3. ユーザー追加を押します
    ユーザー一覧画面から「ユーザーを追加」ボタンを押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user03.jpg)

4. ユーザー名とアクセスの種類を決めます
    - ユーザー名は自由に決めて構いません。AWS全体で使用できるユーザーではなく、特定のAWSアカウント内のみで有効なユーザーのためIDの重複もおきません。
    - 「AWS認証情報タイプ」は「アクセスキー・プログラムによるアクセス」と「パスワード・AWSマネジメントコンソールへのアクセス」の両方を有効にします。AWSの機能を使用していく場合には両方とも必要となります。
    - コンソールのパスワードは「自動生成パスワード」を使用しましょう。不正アクセスされにくいパスワードが自動生成されます。
    - 「パスワードのリセットが必要」はオフににます。自動生成したパスワードをそのまま使うためです。
    - 入力したら「次のステップ：アクセス権限」ボタンを押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user04.jpg)

5. ユーザーに権限を割り当てます
    「既存のポリシーを直接アタッチ」を選択する表示されるリストから「AdministratorAccess」を選択して「次のステップ：タグ」ボタンを押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user05.jpg)

6. タグはスルーします
    タグの設定画面が表示されますが必須の項目ではないため、未設定のまま「次のステップ：確認」を押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user06.jpg)

7. 作成するユーザーの設定を確認します
    作成ユーザーの設定を確認して「ユーザーの作成」ボタンを押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user07.jpg)

8. ログイン情報のメモを取ります
    ユーザーが作成されました。ログインに必要な以下の情報をメモしておきます。
    - サインインのURL（背景色が緑色のメッセージエリア内のリンク）
    - ユーザー
    - アクセスキーID
    - シークレットアクセスキー
    - パスワード
    :::message alert
    シークレットアクセスキーとパスワードはこの画面でしか表示できません。忘れないようにしっかりメモを取ります。
    :::
    ログイン情報のメモをとったら右下の「閉じる」ボタンを押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user08.jpg)

9. ユーザーが作成されていることを確認します
    ユーザーの一覧に作成したユーザーが増えていることを確認します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user09.jpg)

10. ルートユーザーをサインアウトします
    マネジメントコンソール右上のユーザーIDを選択して表示されるメニューから「サインアウト」を押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user10.jpg)

11. IAMユーザーでログインします
    手順10でメモを取ったサインインのURLを表示し、ユーザーとパスワードを入力して「サインイン」ボタンを押します。
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user11.jpg)

12. IAMユーザーでマネジメントコンソールを表示
    作成したIAMユーザーでマネジメントコンソールが表示できました！
    ![select user from iam dashbord](/images/aws_biginner_create_iam_user12.jpg)

# 次はこれをやろう
- とにかくEC2を立ててログインする(鋭意作成中)
