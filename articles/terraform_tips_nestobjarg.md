---
title: "ネストしたオブジェクトを型指定で受け取る - Terraformのきほんと応用"
emoji: "🛴"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "入力変数"]
published: true
---
Terraformコードを書く上での小さなTIPSです。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
ネストしたオブジェクトをvariablesのtypeで受け取りたい場合はmap型を使います。

# コード説明
Terraformを書いていると以下のようなネストしたオブジェクトで設定を定義したくなることがあります。
```hcl:terraform.tfvars
subnets = {
  "application-subnet" = {
    cidr   = "192.168.10.0/24"
    public = true
  }
  "database-subnet" = {
    cidr   = "192.168.100.0/24"
    public = false
  }
}
```
型なしで受け取ることもできるのですが、構造を定義しておいた方がソースの読みやすさが格段に変わってきます。
```hcl:main.tf
// 型なしでうけとる
variables typeless-subnets {}

// 型を指定して受け取る
variable subnets {
  type = map(object({
    cidr   = string
    public = bool
  }))
}

output print-all {
  value = var.subnets
}

output print-keys {
  value = [for k, v in var.subnets : k]
}
```

# 動かしてみる
上記のコードを動かしてみるとネストしたオブジェクトを受け取れていることがわかります。
![run sample](/images/terraform_tips_nestobjarg/terraform_tips_nestobjarg_000.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_tips_nestobjarg])
