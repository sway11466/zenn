---
title: "TypeScriptでちょっとした処理を書く - TypeScript入門"
emoji: "🪟"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["TypeScript"]
published: false
---

# 概要
TypeScriptコードの動作検証や定型処理を自動化したい場合など、お手軽にTypeScriptを実行したい場合があります。


# ゴール
TypeScriptで書いた hello world ソースを直接実行します。
![image title](/images/ts_helloworld/ts_helloworld_goal.jpg)

# 必要なもの
- 作業時間：10分
- nodejs（npm）

# インストールとブラウザ表示

1. typescriptとts-nodeのインストール
   typescript と、お手軽に実行するための ts-node をインストールします。
   ```
   npm install typescript ts-node
   ```
   ![image title](/images/ts_helloworld/ts_helloworld_tutorial_00.jpg)

1. 初期化する
   TypeScriptを実行できるようにtsconfig.jsonを作成します。
   ```
   npx tsc --init
   ```
   ![image title](/images/ts_helloworld/ts_helloworld_tutorial_01.jpg)
   コマンドを実行するとtsconfig.jsonが作成されてます。
   ![image title](/images/ts_helloworld/ts_helloworld_tutorial_02.jpg)

1. hello worldソースを作成する
   hello world!を出力するのみのソースを作成します。
   ```ts:hello.ts
   console.log("hello world!")
   ```

1. TypeScriptで実行する
   TypeScriptで書いたスクリプトの実行はnpx ts-nodeコマンドを使用します。
   ```
   npx ts-node hello.ts
   ```
   無事にhello world!が表示できました。
   ![image title](/images/ts_helloworld/ts_helloworld_tutorial_03.jpg)

1. サンプルコード
   この記事で使用するコードはgithub上に公開しています。
   @[card](https://github.com/sway11466/zenn/tree/main/sample_codes/ts_helloworld)

# 感想
TypeScriptは大規模開発向けの言語とされていますが、ちょっとした処理を書くのにも便利です。
