---
title: "tfstateはS3などの共有ストレージに保存する - Terraformのきほんと応用"
emoji: "⚓"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform"]
published: false
---
Terraformを使う全ての人が実践すべき内容について説明します。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# Teraformのてっぱん
tfstateファイルは共有ストレージに保存する（gitではない）。この共有ストレージはTerraform以外の方法で作る。
- awsならS3
- azureならAzure Storage
- gcpならGCS

# 説明

## 共有ストレージに作成するべき理由
Terraformは構築状態をtfstateファイルに保存します。tfstateファイルは特に指定がなければローカルファイルとして作成されます。複数人で開発するとtfstateファイルの整合性がとれなくなって破綻してしまいます。
では、tfstateをソースと同様にgitで管理するのはどうでしょうか？うまくいきそうな気もしますが、tfstateが競合してマージが必要になった場合を考えてみましょう。。。無理ですね。
tfstateはS3などの共有ストレージに保存しましょう。

## tfstate用共有ストレージをterraformで作らない理由
せっかくTerraformを使うのだからtfstateを管理する共有ストレージもTerraformで作りたくなります。が、この共有ストレージは別の方法で作成するのが良いでしょう。
Teraformで共有ストレージを作ると、そのtfstateをどのように管理すべきかという問題が永久に発生することになります。

## tfstateをS3に置く方法
AWSを使用する場合はtfstateをS3で管理するための機能が用意されています。
ソース内のterraformセクションのbackendセクションに"s3"を設定するだけです。
```hcl:main.tf
terraform {
  backend "s3" {
    bucket = "s3-bucket-name"
    region = "ap-northeast-1"
    key = "terraform.tfstate"
  }
}
```
S3を使う場合は以下の設定で構築するのが良いでしょう。
・パブリックアクセスを無効にする
・バージョニングを有効にする

## tfstate用S3作成スクリプト
tfstate用S3をCLIで作成するスクリプトを作ってみました。[(tfstate用S3作成スクリプト)](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_staple_sharestate/create_tfstate_storage_s3.bat)
スクリプトでは以下3つのAPIを実行しています。
- [create-bucket](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/create-bucket.html)
- [put-public-access-block](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-public-access-block.html)
- [put-bucket-versioning](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3api/put-bucket-versioning.html)

引数にバケット名指定して実行します。
```cmd:
create_tfstate_storage_s3.bat sway-tfstate-share-bucket
```
正常にバケットが作成できた場合は以下のような出力となります。
![version error exsample](/images/terraform_staple_sharestate/terraform_staple_sharestate_desc_01.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_staple_sharestate)

# 次はこれをやろう
- tfstateのロック機能を使う(鋭意作成中)

Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
