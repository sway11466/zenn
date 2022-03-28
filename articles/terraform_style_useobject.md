---
title: "オブジェクト型を活用する - Terraformのきほんと応用"
emoji: "🍳"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "ローカル変数", "入力変数", "戻り値"]
published: true
---
私のTerraformソースの考え方や書き方をつづります。
一般的なプラクティスと異なる部分もあります。また、考えが変わることもあるので同じ記事を継続的に更新します。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 私的Teraformの書き方
オブジェクト型の変数を活用する。

# 説明
ローカル変数（local variables）、入力変数（input variables）、戻り値（output）それぞれでオブジェクト型を使用します。

1. ローカル変数（local variables）
   ローカル変数はHCLの文法にしたがって特に意識することなくオブジェクト型を使用することができます。
   ```hcl
   locals {
       network = {
           cider_vpc       = "10.0.0.0/16"
           cider_subnet_1a = "10.0.0.0/20"
           cider_subnet_1c = "10.0.16.0/20"
           cider_subnet_1d = "10.0.32.0/20"
       }
       web = {
           ami             = "ami-03d79d440297083e3"
           instance_type   = "t3.micro"
       }
       db = {
           engine          = "mysql"
           version         = "5.7"
           instance        = "db.t2.micro"
       }
   }
   ```

1. 入力変数（input variables）
   入力変数はオブジェクト型を明示的に指定することでオブジェクト型が使用できます。
   ```hcl
   variable vpc_parameter {
       type = object({
           cider = string
           tags  = map(string)
       })
   }
   ```

1. 戻り値（output）
   戻り値にもobject型の要素を指定することができます。
   ```hcl:sample_module_network.tf
   resource "aws_vpc" "vpc" {
       // VPCの設定（略）
   }
   output "vpc" {
       value = aws_vpc.vpc
   }
   ```
   上記のようにVPCリソースを丸ごと戻り値に指定することで、[VPCオブジェクトが持つ属性](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#attributes-reference)を他でも使用することができます。
   ```hcl:sample_main.tf
   module "network" {
       source   = "./sample_module_network/"
   }
   module "db" {
       source   = "./sample_module_db"
       vpc_id   = module.network.id
   }
   ```

# 理由
オブジェクト型を使用することで変数をグループ化することができます。このグループに適切な名前をつけることで、ソースが格段に読みやすくなります。
フラットに書いた変数から、全体の構成や各設定が影響する要素を汲み取るのは簡単ではありません。
```hcl:flat_setting.tf
locals {
    cider_vpc          = "10.0.0.0/16"
    cider_subnet_1a    = "10.0.0.0/20"
    cider_subnet_1c    = "10.0.16.0/20"
    cider_subnet_1d    = "10.0.32.0/20"
    web_ami            = "ami-03d79d440297083e3"
    web_instance_type  = "t3.micro"
    db_engine          = "mysql"
    db_version         = "5.7"
    db_instance        = "db.t2.micro"
}
```
オブジェクト型で書いておくと、ネットワーク・Webサーバー・DBサーバーの３つがあり各設定項目が影響する要素がわかりやすくなります。
```hcl:object_setting.tf
locals {
    network = {
        cider_vpc       = "10.0.0.0/16"
        cider_subnet_1a = "10.0.0.0/20"
        cider_subnet_1c = "10.0.16.0/20"
        cider_subnet_1d = "10.0.32.0/20"
    }
    web = {
        ami             = "ami-03d79d440297083e3"
        instance_type   = "t3.micro"
    }
    db = {
        engine          = "mysql"
        version         = "5.7"
        instance        = "db.t2.micro"
   }
}
```
上記はローカル変数（local variables）の例でしたが、入力変数（input variables）や戻り値（output）もオブジェクト型を使用することで読みやすいコードを実現することができます。

# 次はこれを読もう
- tfファイルはリソースのライフサイクルごとにわける(鋭意作成中)
