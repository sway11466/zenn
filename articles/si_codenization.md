---
title: "そのコード化は本当に必要ですか？ - SI屋さんの雑記"
emoji: "🏭"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["SIer", "設計", "コード化"]
published: true
---
ベテランのSI屋さんが考えたことを書き残した雑記です。
SI屋さんにしか通じない単語を説明なしに使うので素人は要注意です。
いろいろな意見を欲しているので、つっこみは大歓迎です。
他の記事は[SI屋さんの雑記](https://zenn.dev/sway/articles/si_index_list)からどうぞ。


## 概要

- 脳死でコード化は思考停止なので辞める
- コード化しない選択肢も考える
- コード化するなら理由を説明できるように


## 1. 素朴な疑問

よく訓練されたSIer屋さんは、業務データを自然とコード化して扱います。
しかし、それって本当に必要なことなのでしょうか？　大昔の慣習を漫然と続けていたり、理由のないプラクティス採用になっていいないでしょうか？


## 2. コード化って何？

私が「コード化」と読んでいる物をTodoアプリの例で説明します。
TodoアプリではTodoとそのステータスを管理するものとします。ステータスは「todo」「doing」「done」の3つの値をとります。このアプリでステータスをコード化する場合としない場合について考えてみます。

- コード化した場合のステータスマスター
   | code | status |
   |------|--------|
   | 0    | todo   |
   | 1    | doing  |
   | 2    | done   |

- コード化しない場合のステータスマスター
   | status |
   |--------|
   | todo   |
   | doing  |
   | done   |

コード化する場合は、ステータスマスターの構造ははcodeとstatusの2カラム構成になります。コード化しない場合はstatusカラムのみの構成です。
この例でいうところのcodeカラムの存在が「コード化」です。todoやdoing等のステータス値ではなく、0や1といった意味を排除した値との組を作成して扱う設計技法です。


## 3. コード化のメリット

まずはコード化するメリットを考えてみます。一般的な慣習になっている以上、なんらかの必要性や効果を得るために行われているはずです。

1. 確立したコード体系が存在している
   現時点で一番大きいメリットはコレだと考えています。たとえば、都道府県コードというものがあります。多くのシステム屋さんは扱ったことがあるのではないでしょうか。

1. ある種の名寄せ
   名称の表記にゆらぎがあるため、名寄せや正規化する目的でコードを使用する場合があります。身近な例では、郵便番号が該当すると思います。住所の表記はバリエーションがありますが、コードにすると同じ意味の集まりとして扱いやすくなります。

1. バーコード等で物理媒体と紐づけやすい
   一部の業務ではコンピューター上のデータを現実世界の物とリンクして扱いたい場合があります。スーパーの棚にならんでいる商品ですね。もし、バーコード（JANコードと呼ばれます）がなかったら商品を管理する業務が非常に大変でしょう。

1. byte数が少ない
   大昔のコンピューターはメモリやストレージが高価であったため、取り扱うデータが1byteでも小さいほうが好ましいという時代がありました。が、今はコレを理由としてコード化する必要は無いように思います。

1. 長さが一定で扱いやすい
   これもCOBOL等の一部のコンピューター言語や古いハードウェアに特化した利点です。桁数が固定であることでコーディング時の取り回しや性能上の利点がありますが、コレもイマドキの採用理由としては弱いでしょう。

コード化のメリットが利用者や業務の効率化である場合は採用すべきでしょう。一方、ハードウェアやソフトウェア開発者に対するメリットを目的とした場合は再考したほうが良さそうです。


## 4. コード化のデメリット

次にコード化によるデメリットを考えてみます。

1. 管理対象が増える
   まず、コードとコードを紐づける対象（名称など）の管理が必要となってきます。突然の一般論ですが、必要ないなら部品点数は少ない方がよいです。故障が減り品質を保ちやすくなります。

1. コード量が増える
   ソースコード上でコード値を直接扱うとマジックナンバーとなるため、イマドキのプログラミング言語では定数やEnumなどに変換して可読性を上げる工夫を行います。でも、これって実装増えてますよね？

1. データの意味や構造の理解を妨げる
   トランザクションのデータ構造がコード値だらけだと、データの意味（業務）を理解するのに苦労します。これは、新規参画メンバーの立ち上がりを遅らせる要因になると考えらます。

1. 思考を妨げる
   すべてのコード値を暗記できるわけではないので（強者はしてしまうが）、障害対応等でトランザクションデータをselectする際に、コード値を調べるかマスターを結合する必要が生じてしまいます。よく知らないシステムの緊急対応などでコード化まみれのデータを見ると、正直めんどくさいです。

コード化することを当たり前だと思わずに、このようなデメリットを暗に受容していることを意識したほうがよさそうです。


## 5. 例えばTodoアプリで考えてみる

コード化の有無による差をTodoアプリで考えてみます。


### 5.1 コード化された世界

- コード化した場合のステータスマスター
   | code (PK) | status |
   |-----------|--------|
   | 0         | todo   |
   | 1         | doing  |
   | 2         | done   |

- コード化した場合のTodoテーブル
   | id (PK) | todo        | status-code(FK) |
   |---------|-------------|-----------------|
   | 0       | unit test   | 0               |
   | 1       | write code  | 1               |

- 実装の容易さ
   - 画面上にステータスを表示するには、ステータスマスターを結合して名称を持ってくる必要があります（面倒）
   - 入力値のバリデーションチェックはステータスマスターで行います（優劣なし）
   - 特定のステータスに対する処理が必要となる場合、コード値をハードコーディングすると可読性が悪いので定数化するかEnumを作成する（面倒）

- 性能
   - 多くの処理でステータスマスターを結合する必要がある
   （無結合に比べれば性能は悪いが、このレベルであれば有意な差はでない）

- データ量
   - Todoテーブルのデータ量はステータスがコード化されている分少ない
   （利点だが、イマドキのストレージコストを考えると考慮すべきほどか？）

- 保守
    - todoテーブルにselect文打っても、ステータスマスタと結合するかコード値を覚えていないと意味がわからない（面倒）


### 5.2 コード化しない世界

- コード化しない場合のコードマスター
   | status (PK) |
   |-------------|
   | todo        |
   | doing       |
   | done        |

- コード化した場合のTodoテーブル
   | id (PK) | todo       | status(FK) |
   |---------|------------|------------|
   | 0       | unit test  | todo       |
   | 1       | write code | doing      |

- 実装の容易さ
   - 画面表示はTodoテーブルのみでよい（楽）
   - 入力値のバリデーションチェックはステータスマスターで行います（優劣なし）
   - 特定のステータスに対する処理が必要となる場合にハードコーディングしても可読性が高い（楽）

- 性能
   - ステータスマスターを結合する必要がない
   （性能は良いが、このレベルであれば有意な差はでない）

- データ量
   - Todoテーブルのデータ量はステータスが値のまま格納されているため多くなる
   （欠点だが、イマドキのストレージコストを考えると考慮すべきほどか？）

- 保守
    - todoテーブルにselect文打つと可読性の高いデータである（楽）


## 6. 結論

5項で上げた単純なTodoアプリであっても、コード化するメリットよりもコード化のデメリットのほうが大きいように思います。
単純な例なので大差ないと考える方も多いと思いますが、実際に扱うような複雑な業務であれば、この差はより広がるのではないでしょうか。同じような問題意識を感じている方の助けになれば、なによりです。


## X. 区分とかIDはどうなの？

コードに似たような概念として区分やIDがでてきます。区分はコードの１つの形態なので同じ論になると考えています。しかし、IDは目的が違うため別の話だと考えています。
そして、コード／区分／IDというものは、所属する組織やコミュニティによって意味は違うと考えられます。
個人的には、irofさんの記事による整理が一番しっくりくるので、この内容の前提で上記を記載しています。
https://irof.hateblo.jp/entry/2021/10/26/181920
