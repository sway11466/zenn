---
title: "休日判定ライブラリを作ってみた - TypeScript実用"
emoji: "🪵"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["TypeScript", "holiday"]
published: false
---


## 概要

TypeScriptによる実用的なライブラリの実装例として休日判定ライブラリを作ってみました。
https://www.npmjs.com/package/@sway11466/holiday-jp-npm


## 特徴

- 内閣府ホームページの[「国民の祝日」について](https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html)に基づいて平日や祝日を判定します

-   判定ルール
    | 日付の種類 | 判定方法 |
    |------------|----------|
    | 平日 | 週末でも祝日でもない日 |
    | 週末 | 土曜日および日曜日（対象となる曜日は設定で変更可能） |
    | 祝日 | 内閣府ホームページの[「国民の祝日」について](https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html)に記載の祝日 |

-   判定の例（2024年5月）
    | 日付の種類 | 5/1(水) | 5/2(木) | 5/3(金) | 5/4(土) | 5/5(日) | 5/6(月) | 5/7(火) |
    |------------|---------|---------|---------|---------|---------|---------|---------|
    | 平日 | 〇 | 〇 | × | × | × | × | 〇 |
    | 週末 | × | × | × | 〇 | 〇 | × | × |
    | 祝日 | × | × | 〇 | 〇 | 〇 | 〇 | × |

- 実行環境のタイムゾーンを考慮してJST換算での判定を行います

- 独自の祝日を追加することも可能です

- 実行時の依存ライブラリはゼロです


## インストール

```bash
npm install @sway11466/holiday-jp-npm
```


## 使い方

-   初期化
    ```typescript
    import { useHolidayJP } from '@sway11466/holiday-jp-npm'
    const holidayjp = useHolidayJP();
    ```
-   指定日が祝日であるか判定する
    ```typescript
    const ret = holidayjp.isHoliday(new Date(2021, 5-1, 3)); // 2021/5/3 憲法記念日
    console.log(ret); // true
    ```
-   指定日が平日であるか判定する
    ```typescript
    const ret = holidayjp.isWeekday(new Date(2021, 5-1, 7)); // 2021/5/7 平日
    console.log(ret); // true
    ```
-   指定した条件に当てはまる祝日を取得する（例１）
    ```typescript
    const holidays = holidayjp.get({ year: 2021, month: 5 });
    console.log(holidays.length);  // 3
    console.log(holidays[0].name); // 憲法記念日
    console.log(holidays[0].localDate); // 2021/5/3のDateオブジェクト
    ```
-   指定した条件に当てはまる祝日を取得する（例２）
    ```typescript
    const holidays = holidayjp.get({ year: 2021, name: "スポーツの日" });
    console.log(holidays.length);  // 1
    console.log(holidays[0].localDate); // 2021/7/23のDateオブジェクト（日本オリンピックによる特別対応日）
    ```
-   独自の祝日を追加する
    ```typescript
    import { useHolidayJP } from '@sway11466/holiday-jp-npm'
    const additional = [{ name: 'test', year: 2023, month: 3, date: 10, localDate: new Date('2023-03-10T00:00:00+09:00') }]; // 金曜日
    const holidayjp = useHolidayJP({ extends: additional });
    const cond = { year: 2023, month: 3, date: 10 };
    const holiday = holidayjp.isHoliday(cond);
    console.log(holiday); // true
    ```


# 動機＆目的

このライブラリは以下のような目的で作成しました。

1. 扱いやすい祝日判定ライブラリが欲しかった
   npmに登録されている祝日判定ライブラリは必要な機能が不足していたり、使い勝手が古くて満足できるものがなかった。

1. npmライブラリを作ってみたかった
   npmライブラリを作成して登録する流れを把握したかった。

1. TypeScriptプロジェクトをゼロから作ってみたかった
   よく使用される以下のライブラリをゼロから投入してひな型となるようなプロジェクトを作っておきたかった。
   - eslint
   - jest
   - prettier
