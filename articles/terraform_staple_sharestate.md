---
title: "tfstateはS3などの共有ストレージに保存する - Terraformのきほんと応用"
emoji: "⚓"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["tags"]
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
- そのtfstateはどうするの問題
- 誤操作怖い
- どのみち1way
- 

## tfstateをS3に置く方法
terraformセクションのbackendセクションに"s3"を設定します。
```hcl:main.tf
terraform {
  backend "s3" {
    bucket = "s3-bucket-name"
    region = "ap-northeast-1"
    key = "terraform.tfstate"
  }
}
```
S3に置く場合は以下の設定を推奨します。
・パブリックアクセスを無効にする
・バージョニングを有効にする

## tfstate用S3作成スクリプト
CLIで以下3つのAPIを実行する
- create
- acl
- history
これらを実行するバッチファイルを準備しました。バケット名をパラメーターとして以下のように使用できます。
```cmd:
create_tfstate_storage_s3.bat sway-tfstate-share-bucket
```
正常に動くと以下のようなります。
![version error exsample](/images/terraform_staple_sharestate/terraform_staple_sharestate_desc_01.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_staple_sharestate)

# 次はこれをやろう
- tfstateのロック機能を使う(鋭意作成中)
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。
