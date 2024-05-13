---
title: "Cloud FunctionsをJPリージョンにデプロイする - Firebaseで遊ぼう！"
emoji: "🐦"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["firebase", "cloudfunctions", "初心者"]
published: false
---
Firebaseを使って遊ぶ記事です。スクリーンショット満載でやった気になれます。

## 概要
FirebaseのCloud FunctionsをJPリージョンにデプロイします。

## ゴール
Cloud Functionsを作成してJPリージョンにデプロイします。
少しわかりにくいですが、関数のhelloworldの下に「asia-northeast1」の表記があり、東京リージョンにデプロイされていることがわかります。
![image](/images/firebase_functions_jpregion/firebase_functions_jpregion_goal.png)

## 必要なもの
- 作業時間：10分
- 費用：無料
- cloudfunctionsが利用可能なfirebaseプロジェクト
    準備できていない場合は [Cloud Functions 最初の1歩](https://zenn.dev/sway/articles/firebase_helloworld_functions) を参考に準備してください。

## 作業手順

### プロジェクト配下のFunctionsをまとめて変更する
関数を追加するごとに日本リージョンを指定するのは面倒なので、すべての関数が日本リージョンにデプロイされるように設定します。
firebaseのCloud Functionsでは、以下のようにsetGlobalOptionsを関数全体の使用リージョンを指定することができます。
デプロイ先が東京の場合は「asia-northeast1」を、大阪の場合は「asia-northeast2」を指定します。

```typescript
import {setGlobalOptions} from "firebase-functions/v2";
setGlobalOptions({
  region: "asia-northeast1",
});

```

これをindex.tsに組み込みます。

```typescript:index.ts
/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

import {setGlobalOptions} from "firebase-functions/v2";
setGlobalOptions({
  region: "asia-northeast1",
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

export const helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
```


### デプロイとブラウザでの動作確認

デプロイ前に現時点のリージョンを確認しておきます。
「us-central1」となっておりUSリージョンとなっています。

![image](/images/firebase_functions_jpregion/firebase_functions_jpregion_001.png)

デプロイして確認してみます。
```bash
firebase deploy
```
![image](/images/firebase_functions_jpregion/firebase_functions_jpregion_002.png)

USリージョンの関数を削除してよいか確認されるので「y」を入力して先に進みます。
デプロイ処理は数分～10分程度かかるので気長に待ちます。
![image](/images/firebase_functions_jpregion/firebase_functions_jpregion_003.png)

「Deploy complete!」と表示されればデプロイ完了です。ブラウザのダッシュボードに戻ってリロードすると、リージョンが「asia-northeast1」となっており東京リージョンにデプロイされたことが確認できます。
![image](/images/firebase_functions_jpregion/firebase_functions_jpregion_004.png)


## まとめ
これで、Functionの追加時にリージョンを気にする必要がなくなりました。
