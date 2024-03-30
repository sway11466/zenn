---
title: "Cloud Functions 最初の1歩 - Firebaseで遊ぼう！"
emoji: "🐦"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["firebase", "cloudfunctions", "初心者"]
published: true
---
Firebaseを使って遊ぶ記事です。スクリーンショット満載でやった気になれます。

## 概要
FirebaseのCloud Functionsを使用したHello Worldです。
Typescripttで作成したColud Functionsをデプロイししてブラウザから呼び出します。

## ゴール
Cloud Functionsを作成してブラウザから呼び出します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_goal.png)

## 必要なもの
- 作業時間：30分
- 費用：無料
- firebaseプロジェクト
    準備できていない場合は [プロジェクトを作成してHTML公開](https://zenn.dev/sway/articles/firebase_helloworld_hosting)　を参考に構築してください。
- クレジットカード
    FirebaseでCloud Functionsを使用する場合は、クレジットカードを登録して重量課金プランに変更する必要があります。費用が心配になるかもしれませんが、このチュートリアルの内容を実施しても課金対象となるレベルの処理は行いません。詳細は「プロジェクトのアップグレード」章を参照ください。

## 作業手順

### プロジェクトのアップグレード

firebaseのプロジェクトは無料と従量課金の2種類のプランがあります。
Cloud Functionsを使用するにはBlazeプランを使用する必要があります。

- Sparkプラン
   無料のプランです。無料なので安心感がありますが、Cloud Functionsは使えません。残念です。

- blazeプラン
   従量課金のプランです。
   従量課金といっても、無料枠が非常に大きいため個人の趣味で検証を行うレベルであれば余裕で無料枠におさまります。

![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_101.png)

まずはプロジェクトのアップグレードを行うため、ダッシュボード左下の「アップグレード」を押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_201.png)

プラン変更の画面が表示されるためBlazeプランの「プランを選択」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_202.png)

請求先アカウントの選択画面が表示されます。請求先アカウントを作成していない場合は「新しい請求先アカウントを作成する」を選択したまま「続行」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_203.png)

請求先アカウントの設定が始まります。最初に対象となる国の選択となるため「日本」を選択します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_204.png)

請求先の名前と企業/組織名とクレジットカード情報を入力します。名前は請求書に使用させる項目なので、個人利用であれば両方とも個人名を入れておけばよいでしょう。クレジットカード情報は決済可能な情報を入力します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_205.png)

続いて請求先の住所を入力します。こちらも請求書に使用される項目です。入力したら「購入を確定」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_206.png)

プロジェクトダッシュボードに戻り予算の設定画面となります。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_207.png)

予算の設定は使用量が課金域に入った場合に早めに知るため1円でも構いません。スクショでは100円を設定しています。設定したら「続行」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_208.png)

Blazeプランへのアップグレードの最終確認画面です。「購入」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_209.png)

上記の操作でアップグレードが完了です。左下のプラン名が「Blaze」になっています。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_210.png)

### Cloud Functions用のファイル群を生成

Cloud Functionにデプロイするためのプロジェクトを生成します。
ダッシュボードのサイドバーの「構成」から「Functions」選択します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_301.png)

firebase-toolsのインストールが促されますが、インストール済みのため「続行」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_302.png)

firebaseプロジェクトの生成を促されますのでコマンドプロンプトを起動します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_303.png)

Functionsを試す新しいプロジェクトを生成するためのフォルダを作成します。
```bash
mkdir firebase_helloworld_functions
```
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_304.png)

カレントディレクトリを生成したフォルダに切り替えます。
```bash
cd firebase_helloworld_functions
```
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_305.png)

firebaseプロジェクト作成を開始します。
```bash
firebase init
```
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_306.png)

プロジェクト作成を開始するために「Y」を入力します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_307.png)

生成するプロジェクトの種類を聞かれるため「Functions」を選択（スペースキー押下）してエンターキーを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_308.png)

FirebaseProjectの追加について聞かれるため「Use an existing project」を選択してエンターキーを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_309.png)

表示されたプロジェクトの中から使用するプロジェクトを選択してエンターキーを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_310.png)

使用する言語を聞かれるので「TypeScript」を選択してエンターキーを押下します。他の言語でも構いませんが、このチュートリアルはTypeScript前提で進めます。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_311.png)

Lintについて何か聞かれるので「Y」を押下しておきます。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_312.png)

生成前の確認なので「Y」を押下して先に進めます。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_313.png)

プロジェクトの生成が始まるので数分間待ちます。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_314.png)

プロジェクトの生成が完了しました。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_315.png)

プロジェクトフォルダにファイル群が作成されていることを確認します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_316.png)

生成されたファイル群から「functions/src/index.ts」を探してメモ帳で開きます。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_317.png)

「export const～」以降の行のコメントを解除します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_318.png)

ソースを以下の状態にして保存します。これでソースの準備は完了です。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_319.png)

### デプロイとブラウザでの動作確認

引き続きコマンドプロンプトでデプロイ操作を行います。
```bash
firebase deploy
```
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_401.png)

デプロイ処理は数分～10分程度かかるので気長に待ちます。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_402.png)

「Deploy complete!」と表示されればデプロイ完了です。ブラウザのダッシュボードに戻ります。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_403.png)

デプロイまで完了しているため「完了」ボタンを押下します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_404.png)

ダッシュボードにデプロイした「helloworld」関数が表示されているので選択します。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_405.png)

デプロイ直後のため呼び出し履歴はありませんが、情報を見ることができます。画面中央に関数のURLが記載されているため（「リクエスト」の下あり）、コピーして別タブで表示してみましょう。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_406.png)

「Hello from  Firebase!」と表示されることが確認できれば完了です。
![image](/images/firebase_helloworld_functions/firebase_helloworld_functions_tutorial_407.png)

## まとめ
スクリーンショットは多いのですが、少ない手順でFunctionsのデプロイが行えました。
