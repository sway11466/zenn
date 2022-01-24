---
title: "variable.tfとoutputs.tfを分けない - Terraformのきほんと応用"
emoji: "🍳"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform"]
published: true
---
私のTerraformソースの考え方や書き方をつづります。
一般的なプラクティスと異なる部分もあります。また、考えが変わることもあるので同じ記事を継続的に更新します。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 私的Teraformの書き方
リソース定義ファイル内に引数や戻り値を書き、別のファイルにわけない。

# 説明
terraformの入門記事を見ると以下のようなファイル構成の説明が多く出てきます。
が、私はこの構成が好きではありません。
```
vpc/
├── main.tf       // リソースの定義
├── valiables.tf  // 引数の定義
└── outputs.tf    // 戻り値の定義
```
以下のように1ファイルにまとまってた方が読みやすく変更しやすいと思います。
```hcl:vpc.tf
// 引数
variable "vpc_cider" {}

// リソース定義
resource "aws_vpc" "main" {
  cidr_block = $var.vpc_cider
}

// 戻り値
output "vpc_id" {
  value  = aws_vpc.main.id
}
```

# 理由
1ファイル構成が良いと考えている一番の理由はリソースごとにファイルを分けたいからです。
たとえば、VPCとEC2の定義を行う場合を考えてみます。
よく見るフィル分離構成の場合は以下のような構造になります。
```
./
├── main.tf
│    ├── VPCの定義
│    └── EC2の定義
├── valiables.tf
│    ├── VPCの引数
│    └── EC2の引数
└── outputs.tf
     ├── VPCの戻り値
     └── EC2の戻り値
```
EC2の引数と戻り値が変わる修正が発生した場合は3つのファイルを修正することになります。面倒です。
一方、1ファイルにしておくとこうなります。
```
./
├── vpc.tf
│    ├── VPCの引数
│    ├── VPCの定義
│    └── VPCの戻り値
└── ec2.tf
     ├── EC2の引数
     ├── EC2の定義
     └── EC2の戻り値
```
EC2の変更が発生した場合の修正はec2.tfのみで完結します。ec2を別のフォルダに移動するなどのリファクタリングも容易になります。
また、ソースを読む際に必要な情報も1ファイルに集まっているので読みやすいので、valiables.tfとoutputs.tfに分離する一般的なプラクティスはイケてないと考えています。

# 次はこれを読もう
- tfファイルはリソースのライフサイクルごとにわける(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
