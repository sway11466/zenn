---
title: "公式モジュール(Terraform Registry)の使い方 - Terraformのきほんと応用"
emoji: "🛴"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "モジュール", "TerraformRegistry"]
published: false
---
Terraformコードを書く上での小さなTIPSです。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 概要
Terraformのモジュール機能を活用した様々なモジュールが[Terraform公式サイト](https://registry.terraform.io/browse/modules)にて配布されており簡単に使用できます。
この中からsubnetsモジュールというIPv4ネットワークアドレスの生成に使用できるモジュールを使ってみます。クラウドリソースは作成しませんが、インターネット接続は必要になります。

# 公式モジュールの使い方
公式モジュールといっても、使い方は通常のモジュールと同じです。sourceで指定するパスに[Terraform公式サイト](https://registry.terraform.io/browse/modules)の値を使います。
その中の1つの[subnetsモジュール](https://registry.terraform.io/modules/hashicorp/subnets/cidr/latest)は、ベースとなるcidrから指定したアドレス帯のciderを作るモジュールです。
```hcl  
module "subnets" {
  source = "hashicorp/subnets/cidr"
  base_cidr_block = "10.0.0.0/8"
  networks = [
    { name = "subnet-1a", new_bits = 4 },
    { name = "subnet-1c", new_bits = 4 },
    { name = "subnet-1d", new_bits = 4 },
  ]
}

output all {
  value = module.subnets
}

output ciders {
  value = module.subnets.networks[*].cidr_block
}
```

# 動かしてみる
直前の操作の後の状態
操作手順の説明
操作後の状態
![image title](/images/[article_title]/[article_title]_tutorial_00.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/[article_title]])
