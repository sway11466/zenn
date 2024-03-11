---
title: "プロジェクトを作成してHTML公開 - Firebaseで遊ぼう！"
emoji: "🐦"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["firebase", "初心者"]
published: true
---
Firebaseを使って遊ぶ記事です。スクリーンショット満載でやった気になれます。

## 概要
Firebaseのホスティング機能を使用した Hello World です。
ホスティング用のHTMLを作成してプロイします。

## ゴール
Firebaseにプロジェクトを作成してHTMLを公開します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_goal.png)

## 必要なもの
- 作業時間：30分
- 費用：無料
- googleアカウント

## 作業手順

### Firebaseプロジェクトの作成

https://firebase.google.com をブラウザで表示して、「使ってみる」ボタンを押下します。   
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_101.png)

「プロジェクトの作成」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_102.png)

「プロジェクト名」に任意のプロジェクト名を入力して「Firebaseの規約に同意します」と「自身の取引、ビジネス～」の2つのチェックボックスをオンにして「続行」を押下します。
:::message
プロジェクト名はFirebase全体でユニークである必要があります。Gmailのメールアドレス等と同じですね。
:::
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_103.png)

「このプロジェクトでGoogleアナリティクスを有効にする」をオンにして「続行」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_104.png)

「新しいGoogleアナリティクスアカウント名」を入力して「保存」を押下します。
ここではFirebaseプロジェクト名と同じ名前が使用できます。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_105.png)

「Googleアナリティクスデータ共有～」と「Googleアナリティクス利用規約～」の2つのチェックボックスをオンにして「プロジェクトを作成」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_106.png)

プロジェクトの作成完了までしばらく待ちます。私が試したときは1分ぐらいでした。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_107.png)

プロジェクトが完成したら「続行」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_108.png)

プロジェクトのダッシュボード画面に遷移します。これで、作成作業はすべて完了です。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_109.png)

### ホスティングの作成とデプロイ

プロジェクトダッシュボードのメニューから「Hosting」を選択します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_200.png)

Hostingメニューに遷移するので「始める」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_201.png)

Hostingのセットアップ画面に遷移するので指示に従って操作を続けます。
まずは、コマンドプロンプトを表示してfirebase-toolsをインストールします。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_210.png)

セットアップに使用するフォルダを作成して、カレントディレクトリにします。
```bash
mkdir firebase_helloworld
cd firebase_helloworld
```
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_211.png)

以下のコマンドを実行して firebase-tools のインストールを始めます。
```bash
npm install -g firebase-tools
```
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_212.png)

インストールが完了したらブラウザのセットアップ画面に戻ります。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_213.png)

「Firebase Javascript SDKをウェブアプリを～」のチェックボックスをオンにして「次へ」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_214.png)

次のような画面となるので、再びコマンドプロンプト画面に切り替えます。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_220.png)

以下を実行してgoogleアカウントへのログインを開始します。
```bash
firebase login
```
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_221.png)

Firebaseによる情報収集の許可を求められるためエンターキーを押下します。（Yを入力してもOKです）
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_226.png)

自動的にブラウザが起動するので（起動済みの場合はタブ追加）、Googleにログインするアカウントを選択します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_222.png)

説明画面が表示されるので「次へ」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_223.png)

FirebaseCLIが要求するアクセスを求められるため「許可」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_224.png)

以下の画面が表示されれば権限付与は完了です。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_225.png)

セットアップ画面に戻って次の手順を確認します。再びコマンド実行のためコマンドプロンプト画面に切り替えます。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_230.png)

以下を実行してホスティング用に初期化します。処理続行を聞かれるのでエンターキーを押下します。（Yを入力してもOKです）
```bash
firebase init
```
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_231.png)

作成対象のプロジェクトの種類が聞かれるので「Hosting: Configure files for～」を選択します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_232.png)

firebaseプロジェクトの設定について聞かれるので「Use an existing～」を選択します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_233.png)

先ほど作成したプロジェクトが表示されるのでエンターキーを押下します。（スクショではsway-hello-worldが表示されています）
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_234.png)

ディレクトリの作成有無を聞かれるのでエンターキーを押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_235.png)

シングルページアプリか聞かれるので「N」を入力します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_236.png)

GitHubとの連携について聞かれるので「N」を入力します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_237.png)

これで初期設定は完了です。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_238.png)

フォルダ内にファイルが生成されていることを確認します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_239.png)

publicフォルダにはHTMLが作成されているので表示して確認します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_240.png)

Firebase Hostingセットアップ完了のHTMLであることが確認できます。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_241.png)

セットアップ画面に戻って「次へ」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_230.png)

ウェブアプリの名前を入力して「登録して続行」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_251.png)

「Firebase SDKの追加」は「npmを使用する」のまま「次へ」を押下します。
コマンドの実行が記載されていますが、このタイミングで実行する必要はありません。（実行しても問題ありません）
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_260.png)

以下の内容が表示されます。再びコマンド実行のためコマンドプロンプト画面に切り替えます。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_270.png)

コマンドプロンプトで以下を実行してデプロイを開始します。
```bash
firebase deploy
```
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_271.png)

デプロイが完了する以下のような画面となります。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_272.png)

セットアップ画面に戻って「コンソールに進む」を押下します。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_270.png)

ダッシュボードでアプリがデプロイされていることを確認できます。
「ドメイン」にあるURLをクリックするとデプロイしたHTMLを表示することができます。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_273.png)

以下のような画面となり、ローカルで確認したHTMLがデプロイされていることが確認できます。
以上でHostingのデプロイが完了です。
![image](/images/firebase_helloworld_hosting/firebase_helloworld_hosting_tutorial_274.png)

## まとめ
スクリーンショットは多いのですが、少ない手順でHTMLのデプロイが行えました。
ローカルでHTMLを修正して「firebase depoly」コマンドでデプロイする。というのがFirebase Hostingでの基本の流れとなります。
