---
title: "QuasarFrameworkでお手軽に構築 - Vue3入門"
emoji: "🐉"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["vue3", "TypeScript", "QuasarFramework"]
published: false
---

# 概要
2020年9月にリリースしたVue3ですが、色々なライブラリが対応してきて身近になってきたので、そろそろ触っておこうと思います。せっかくなのでTypeScriptも使います。
Vue3を素で書いてもよいのですが、UIライブラリやCLIが充実しているQuasarFrameworkを使ってお手軽に始めます。

# ゴール
QuasarFrameworkでhello Worldを表示します。
![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_goal.jpg)

# 必要なもの
- 作業時間：15分
- nodejs（npm）

# 作業手順

## インストールとプロジェクトの作成

1. QuasarFrameworkのインストール
   公式の手順ではグローバルインストールですが（-gオプションあり）、ローカルインストールします（-gオプションなし）。個人の好みです。
   ```
   npm install @quasar/cli
   ```
   @[card](https://quasar.dev/quasar-cli/installation)
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_00.jpg)
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_01.jpg)

1. プロジェクトを作成する
   QuasarCLIのnewコマンドを使用してプロジェクトの作成を開始します。
   ```
   npx quasar new
   ```
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_02.jpg)
   プロジェクトの設定を対話式で入力していきます。プロジェクト名やCSSはお好みで。Vue3はTypeScriptもイケるらしいので有効にします。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_03.jpg)
   コンポーネントスタイルはVue3で導入されたCompositionAPを選択します。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_04.jpg)
   lintやパッケージマネージャーはお好みで。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_05.jpg)
   ここまでくれば、完了を待つだけです。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_06.jpg)
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_07.jpg)

1. 開発サーバーを起動する
   開発サーバーの起動はquasar devコマンドを使用します。
   ```
   npx quasar dev
   ```
   起動中は以下のように状況が表示されます。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_08.jpg)
   正常に起動すると以下のような画面となります。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_09.jpg)

1. ブラウザで表示する
   サーバーが起動すると自動的にブラウザでhttp://localhost:8080が表示されています。
   ![image title](/images/vue3_quasarframework_helloworld/vue3_quasarframework_helloworld_tutorial_09.jpg)

# 感想
私はちょっとしたものをVueで作る場合はQuasarFrameworkをよく使用します。UIライブラリがついていて、Vuexやaxiosなどよく使われるライブラリを使った構成を簡単に作れるためです。
この記事はインストールのみでVue3にまったく入門してませんので、次の記事からVue3の特徴に触れていきたいと思います。
