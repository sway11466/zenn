---
title: "環境別にWordPressを構築する（実践編） - Terraformのきほんと応用"
emoji: "🏰"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "AWS", "WordPress"]
published: true
---
TerraformでAWSを構築する際のひな形となるコードを公開しています。個別のコンポーネントではなくコードベース全体です。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 特徴
ALB+EC2+RDSによるWordPressを複数環境管理するためのコードサンプルです。
[フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder)を実践的なコードに置き換えたものです。

# システム構成
- 3つの環境
   - 開発環境
   - ステージング環境
   - 本番環境
- ALB＋EC2+RDSのシンプルな構成
![system structure](/images/terraform_codebase_wordpress_envbyfolder/terraform_codebase_wordpress_envbyfolder_structure_00.jpg)

# ソース構成
- envsフォルダ内に環境ごとのフォルダを作成します
- wordpressはネットワーク、サーバー、DBの3つのモジュールに分けます
```
terraform/
 ├─── envs/
 │    ├─── develop/
 │    │    ├─ main.tf
 │    │    └─ setting.tf
 │    ├─── staging/
 │    │    ├─ main.tf
 │    │    └─ setting.tf
 │    └─── production/
 │         ├─ main.tf
 │         └─ setting.tf
 └─── modules/
      ├─── network/
      │    └─ network.tf
      └─── wordpress/
           ├─── app/
           │    └─ application.tf
           │    └─ application_ec2_userdata.sh
           └─── db/
                └─ database.tf
```
# 使用方法
1. 各環境を構築する
   開発環境、ステージング環境、本番環境それぞれを構築します。流れは[フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder#サンプルコードによる実演)を参照のこと。
1. 3つの環境が作成されていることを確認します
   3つの環境それぞれのURLにアクセスしてWordPressが動作することを確認します。
   WordPressの初期画面は環境ごとの差がないので、3つのVPCのスクショです。
![envs vpc](/images/terraform_codebase_wordpress_envbyfolder/terraform_codebase_wordpress_envbyfolder_tutorial_00.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_codebase_wordpress_envbyfolder)
