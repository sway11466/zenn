---
title: "複数環境を管理する方法の選び方 - Terraformのきほんと応用"
emoji: "🍳"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "複数環境"]
published: true
---
私のTerraformソースの考え方や書き方をつづります。
一般的なプラクティスと異なる部分もあります。また、考えが変わることもあるので同じ記事を継続的に更新します。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 私的Teraformの書き方
状況に応じて複数環境の管理方法を決める。残念ながら唯一の正解はない。

# 説明
Terraformを実践で使うには複数環境を管理する方法を決める必要があります。いくつかのやり方があるため状況に応じて選びます。代表的な手法と特徴は以下の通りと考えていいます。
![image title](/images/terraform_style_envcomparisontable/terraform_style_envcomparisontable_00.jpg)
それぞれの方法を詳しく説明できるとよいのですが、記事として準備できているのはフォルダ管理のみです。今後追加していく予定です。

# 次はこれを読もう
1. [フォルダで複数環境管理（エッセンス編）](https://zenn.dev/sway/articles/terraform_biginner_envbyfolder)
1. [フォルダで複数環境管理（実践編）](https://zenn.dev/sway/articles/terraform_codebase_wordpress_envbyfolder)
1. パラメーターファイルで複数環境管理（エッセンス編）(鋭意作成中)
1. ワークスペースで複数環境管理（エッセンス編）(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
