---
title: "設計を理解しやすいソース構成で書く - Terraformのきほんと応用"
emoji: "🍳"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "ソース構成", "AWS"]
published: false
---
私のTerraformソースの考え方や書き方をつづります。
一般的なプラクティスと異なる部分もあります。また、考えが変わることもあるので同じ記事を継続的に更新します。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 私的Teraformの書き方
設計を理解しやすいようにファイルを分ける。リソース単位でファイルを分けない。

# 説明
公開されているサンプルソースの多くは、リソース単位でファイルを分けています。
```
./
├── ec2.tf
├── subnet.tf
└── security_group.tf
```
このようなソース構成は、使うリソースがわかりやすいので単発トピックの説明には適しています。しかし、全体像やコンポーネント間の関連がわかりにくいので一定規模を超えるシステムでは保守性が低くなります。

これに対して、システム上のコンポーネント単位にファイルを分ける方法があります。
```
./
├── front.tf
├── back.tf
└── batch.tf
```
このようなソース構成は、システム構成を理解しやすくコンポーネント内で必要リソースが閉じるので保守性が高くなります。
上記はファイルの例で説明しましたがモジュールも同様です。

# もう少し具体的な例
WebViewのスマホアプリを例にファイル構成を見比べて考えてみましょう。後述するシステム構成を理解しやすいのは、どちらのソース構成でしょうか。

## 比較用のシステム構成
- SPAのスマホアプリ
    - S3でコンテンツを配信する
    - 動的要素はAPIで取得する
    - プッシュ通知を受け取る（Lamdaで送信する）
- 管理システム
    - インターネット経由のwebアプリ
    - バッチ処理がある（Lambdaで処理）
- ネットワークとデータベースは共用
    - 同一VPC/subnetを使う
    - Auroraを使う
![system architecture](/images/terraform_style_srcstructure/terraform_style_srcstructure_00.jpg)

## リソース別のファイル構成
まずは、リソース単位のファイル構成の例です。AWSコンソールでの分類をベースにしています。
```
sample-spa/
│
├── compute/
│   ├─ alb.tf
│   ├─ ec2.tf (front用ec2はauto_scalingとして書く)
│   └─ lambda.tf
│
├── database/
│   └─ aurora.tf
│
├── network/
│   ├─ security_group.tf
│   ├─ subnet.tf
│   ├─ nate_gateway.tf
│   └─ vpc.tf
│
├── security/
│   └─ iam.tf
│
└── storage/
    └─ s3.tf
```

## 設計を意識したファイル構成
次に、コンポーネント単位のファイル構成の例です。セキュリティグループやIAMポリシーは付与対象のリソースと同じファイルに定義します。
```
sample-spa/
│
├── back/
│   ├─ alb.tf
│   ├─ ec2.tf
│   └─ batch.tf (バッチ処理用lambdaとその関連定義)
│
├── front/
│   ├─ alb.tf
│   ├─ ec2.tf (auto_scalingとして書く)
│   ├─ push.tf (push通知用lambdaとその関連定義)
│   └─ s3.tf
│
├── database/
│   └─ aurora.tf
│
└── network/
    ├─ vpc.tf
    ├─ public.tf (nat_gatewayも定義する)
    └─ private.tf
```

## 比較してみると
設計を意識したファイル構成の方が、システム構成図に対応していて理解しやすいと感じる方が多いのではないでしょうか。
システム構成を理解しやすい以外にも、複数人で開発しやすいと言うメリットがあります。terraformのapplyをモジュール単位に行う機能を使って、モジュール単位に開発を分散・並走させることができるためです。

# 次はこれを読もう
- [複数環境を管理する方法の選び方](https://zenn.dev/sway/articles/terraform_style_envcomparisontable)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
AWS関連の記事も「[AWSをはじめからていねいに](https://zenn.dev/sway/articles/aws_index_list)」で書いてます。
