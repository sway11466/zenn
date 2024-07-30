---
title: "wingetでterraformのインストール - Terraformのきほんと応用"
emoji: "🛴"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "初心者", "winget", "install"]
published: false
---
ていねいを心掛けたTerraform記事です。スクリーンショット満載でやった気になれます。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

## 概要
私がterraformを使い始めたころはWindowsにスタンダードなパッケージマネージャーが存在していなかったのですが、現時点ではwingetというコマンドラインツールがスタンダードの地位を確立していると考えています。
wingetでterraformをインストールするショートtipsです。

## ゴール
wingetでterraformをインストールする。
![image title](/images/terraform_tips_winget/terraform_tips_winget_goal.jpg)

## 必要なもの
- 作業時間：5分

## terrformのインストール手順

### インストール可能か調査する
コマンドプロンプトを起動し、wingetコマンドとshowオプションでterraformの情報を確認します。
```bash
winget show Hashicorp.Terraform
```
バージョン1.9.3がインストールされるようです。[HashiCorpのサイト](https://developer.hashicorp.com/terraform/install?product_intent=terraform)で配布されている安定板の最新バージョンと同じです。
![image title](/images/terraform_tips_winget/terraform_tips_winget_tutorial_00.jpg)

### インストールする
続いてインストールします。
```bash
winget install Hashicorp.Terraform
```
「インストールが完了しました」と表示されたら完了です。
![image title](/images/terraform_tips_winget/terraform_tips_winget_tutorial_01.jpg)

### 正常にインストールされたか確認する
最後にterraformコマンドの動作確認を行います。
新しくコマンドプロンプトを起動して確認します。
```bash
terraform --version
```
:::message
新しいコマンドプロンプトを起動してください。インストールに使用したコマンドプロンプトでは、terraformコマンドにパスが通っておらず意図した結果となりません。
:::
問題なくterraformコマンドが使用できそうです。wingetでインストールすると環境変数pathの設定も自動で行われるため楽です。
![image title](/images/terraform_tips_winget/terraform_tips_winget_tutorial_02.jpg)

## wingetを使うメリット
terraformはzipを展開するだけで利用可能なので手動インストールでも手間は少ないのですが、以下の点がメリットとなります。
- 環境構築手順がコマンド1行で済む
- チーム内でのバージョン統一が楽
   たとえば、1.8系をインストールしたい場合は以下のように指定します。
   ```bash
   winget install Hashicorp.Terraform  --version 1.8.5
   ```
- コマンドライン実行なのでサーバー構築自動化しやすい
