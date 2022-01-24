---
title: "Terraformバージョンを固定する - Terraformのきほんと応用"
emoji: "⚓"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform"]
published: false
---
Terraformを使う全ての人が実践すべき内容について説明します。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# Teraformのてっぱん
開発に使うTerraformとproviderのバージョンを制限する。ただしバグフィックスなどのパッチバージョンの更新は行う。
```hcl:main.tf
terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73.0"
    }
  }
}
```

# 説明

## バージョン形式
Terraformのバージョン形式に関するドキュメントは見当たらないのですが、providerの開発ガイドではセマンティックバージョニングという一般的な考え方を推奨しているため、Terraform本体も同様と考えています。
@[card](https://www.terraform.io/plugin/sdkv2/best-practices/versioning)
セマンティックバージョニングでは、バージョンを**X.Y.Z**の形式で表します。Xはメジャーバージョン、Yはマイナーバージョン、Zはパッチバージョンを表します。ソースの修正が必要となる可能性がある変更が行われた場合には、メジャーバージョンやマイナーバージョンが上がります。

## バージョンを制限する理由
Terraformによる環境構築を複数人で行っている場合、使用しているバージョンが異なると問題になることがあります。たとえば、古いバージョン（0.12未満）で作成したソースを新しいバージョン（0.12以上）で実行するとエラーとなってしまいます。このため、ソースに対応したバージョンで動くように制限を入れることで問題に対応します。
ただし、バグ修正などソース変更を伴わないアップデートには追随すべきです。メジャーバージョンとマイナーバージョンは慎重にアップデートしたいけど、パッチバージョンは自由にあげたい。これが、Terraformによぬ開発の考え方です。

## バージョン番号を固定する方法
Terraform本体のバージョンを制限する場合はterraformセクションのrequired_versionを使用します。providerのバージョン制限はrequired_providersを使用します。
バージョンの指定方法はいくつかありますが「~>」という演算子を使うことでメジャーバージョンとマイナーバージョンがあっていない場合はエラーとすることができ、これ以外の表現を使用する機会はほとんどないと思います。
以下はTerraform本体のバージョンを**1.1.X**に、AWSProviderのバージョンを**3.73.X**に制限する場合の例です。
```hcl:main.tf
terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73.0"
    }
  }
}
```
この定義がある状態で不当なバージョンのTerraformを実行すると以下のようなエラーとなり実行できなくなります。
![version error exsample](/images/terraform_staple_fixversion/terraform_staple_fixversion_desc_01.jpg)
:::message
「~>」以外の表現を使う機会はないと思いますが、念のため他の表記方法が書かれたリンクを残しておきます。
@[card](https://learn.hashicorp.com/tutorials/terraform/versions)
:::

# 次はこれをやろう
- tfstateはS3などの共有ストレージに保存する(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
