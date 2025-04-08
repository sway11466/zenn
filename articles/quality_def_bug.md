---
title: "バグってなに？ - ソフトウェア品質用語集"
emoji: "🎯"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["ソフトウェア品質"]
published: true
---
ソフトウェア品質について様々な観点から考える記事群です。
品質関連の他の記事は「[ソフトウェア品質の探求](https://zenn.dev/sway/articles/quality_index_list)」からどうぞ。


## はじめに
「バグ」という単語はソフトウェア開発者のみならず一般の方にも使用されます。しかし、誰もが納得する定義はなく国際的な規格で言及されることも希だと思います。
また、不具合や故障と呼ばれることもあり「バグ」という単語はカオスの極みです。この状況に自分なりの整理をつけるための記事です。
現時点では記録としての要素が強く、私の気づきとともに更新していく予定です。


## 誰かの定義


1. JSTQBでの定義

   :::message
   バグとは欠陥の別称である。
   欠陥は、要件仕様書やテストスクリプトのようなドキュメント、ソースコード、またはビルドファイルのような補助的なアーティファクトの中から発見できる。
   コードの欠陥が実行されると、システムがすべきことをしない、またはすべきでないことをしてしまうことがあり、故障の原因となる。
   :::

   ソフトウェアテストの教科書と呼ぶべき[JSTQBのシラバス(2023V4.0.J02)](https://jstqb.jp/syllabus.html)の抜粋です。
   やや恣意的に要約すると「バグとはソースコード等に存在しており、実行すると故障を引き起こすもの」という定義です。
   仕様書にもあると明示されているので、仕様バグのようなものも想定しているのでしょう。
   &nbsp;


1. ISTQBでの定義

   :::message
   A flaw in a component or system that can cause the component or system to fail to perform its required function, e.g., an incorrect statement or data definition. A defect, if encountered during execution, may cause a failure of the component or system.
   コンポーネントまたはシステムにおいて、その要求された機能を実行できなくなる原因となり得る欠陥。例えば、誤った記述やデータ定義など。欠陥が実行されると、コンポーネントまたはシステムの故障を引き起こす可能性がある。
   :::

   JSTQBの親分にあたるISTQBでも[bug](https://istqb-glossary.page/bug/)と[defect](https://istqb-glossary.page/defect/)（欠陥）は同一視されています。（説明文が完全に同じです）
   しかし、その定義は少し異なるように思います。
   JSTQBでは「要求使用者」や「ソースコード」といった開発者が作成する成果物を名指ししているのに対し、ISTQBでは「コンポーネント」という曖昧な単語が使われています。個人的な感覚になってしまいますが、開発者がコントロールできない広範囲な対象を示しているように思いました。
   &nbsp;


1. ガートナーでの定義

   :::message
   A bug is an unexpected problem with software or hardware.
   バグとは、ソフトウェアまたはハードウェアにおける予期しない問題のことです。
   :::

   IT分野でのレポートも多い[ガートナー社のバグの定義](https://www.gartner.com/en/information-technology/glossary/bug)からの抜粋です。
   比較的しっくりくる定義です。「予期」って誰の？とか、問題って何？という曖昧さは残るものの、端的で良いです。
   &nbsp;


1. SQuBOK（JIS X 0014:1999）での定義

   :::message
   未定義。。。？
   :::

   Web上で探す限りは見つからなかった。手元に書籍が無いので、後日調べてみよう。
   &nbsp;


## バグってなに？（ver 2025.04.09）

   [品質の記事](https://zenn.dev/sway/articles/quality_def_software_quality)では自分なりの品質の定義を定めていました。バグについても自分なりの定義を考えたいと思います。
   :::message
   バグとは誰かの要求の実現を妨げるものである
   :::
   と定義したいと思います。これは、現時点の私の品質の定義[^1]と対になっています。
   要求に答えられていなければ、仕様通りに実装されていたとしてもバグなのです。これは、一部の開発者は嫌がる定義かもしれませんが、品質を大事にする私には妥当な定義だと考えています。（自分が作成したソフトウェアであれば、バグ報告は全て嬉しいものです。自分の作品をカイゼンさせるのに役に立つからです。）
   [^1]: 品質とは誰かの要求を価値に変えることである(Quality is turning someone's requirements into value)
