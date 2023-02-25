---
title: "TypeScript+Puppeteerでスクレイピング - TypeScript入門"
emoji: "🪟"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["TypeScript", "Puppeteer", "scraping"]
published: false
---

# 概要
スクレイピングといえばPythonがスタンダードですが、TypeScriptで書きたい事もあるんです。
Headless Chrome（見えない画面で動くChrome）を手軽に使えるPuppeterでスクレイピングにチャレンジしてみます。

# ゴール
Zennのトップページの記事一覧を出力する。
![image title](/images/ts_puppeteer_scraping/ts_puppeteer_scraping_goal.jpg)

# 必要なもの
- 作業時間：10分
- nodejs（npm）
- TypeScriptが動く環境
    :::message
    TypeScriptを動かす流れはこちらを参照のこと。
    [TypeScriptでちょっとした処理を書く](https://zenn.dev/sway/articles/ts_helloworld)
    :::

# Puppeteerのインストールと実行

1. Puppeteerのインストール
   Puppeteerをインストールします。
   ```
   npm install puppeteer
   ```
   ![image title](/images/ts_puppeteer_scraping/ts_puppeteer_scraping_tutorial_00.jpg)

1. スクレイピングするソースを作成する
   トップページの記事タイトルを列挙してスクショをとるソースを作成します。
   ```ts:scraping.ts
   import puppeteer from "puppeteer";
   
   const main = async () => {
     const browser = await puppeteer.launch()
     const page = await browser.newPage()
     await page.goto("https://zenn.dev")
   
     // トップページの記事タイトルを列挙する
     const titles = await page.$$eval('h2', list => list.map(e => e.textContent))
     console.log(titles)
   
     // トップページのスクショを残す
     await page.screenshot({ path: "C:/typescript/zenntop.png" });
   
     await browser.close()
   }
   
   main()
   ```

1. TypeScriptで実行する
   npx ts-nodeコマンドで実行します。見えないところでChromeが起動するため少し時間がかかります。
   ```
   npx ts-node scraping.ts
   ```
   記事の一覧が表示されました。
   ![image title](/images/ts_puppeteer_scraping/ts_puppeteer_scraping_tutorial_01.jpg)
   トップページのスクショも作成されています。
   ![image title](/images/ts_puppeteer_scraping/ts_puppeteer_scraping_tutorial_02.jpg)

# サンプルコード
   この記事で使用するコードはgithub上に公開しています。
   @[card](https://github.com/sway11466/zenn/tree/main/sample_codes/ts_helloworld)
