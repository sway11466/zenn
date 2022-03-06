---
title: "ALB+EC2+RDSのミニマル構成 - Terraformのきほんと応用"
emoji: "🏰"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "AWS", "WordPress"]
published: true
---
TerraformでAWSを構築する際のひな形となるコードを公開しています。個別のコンポーネントではなくコードベース全体です。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 特徴
AWS＆Terraformの初心者向けの構成です。
- ALB＋EC2＋RDSの定番構成によるWordPress
- Terraformの難しい機能であるモジュールやワークスペースを使用していない

# システム構成
ALB＋EC2+RDSのシンプルな構成です。
![system structure](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_structure_00.jpg)

# ソース構成
6本のソースで構成しています。
![sourcecode](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_code_00.jpg)
1. application.tf
   ALBとEC2に関連するリソースを定義しています。
1. application_ec2_userdata.sh
   EC2構築時に実行するWordPressのインストールのスクリプトです。EC2のUserDataとして使用します。ここのソースを書き換えればWordPress以外のサービスも構築可能です。
1. database.tf
   RDSに関連するリソースを定義しています。
1. main.tf
   Terrafor自体のバージョン縛りや、AWSプロバイダーの設定です。
1. network.tf
   VPCを定義しています。
   このファイルで定義しているサブネットは使用していません。ALB、EC2、RDSなどリソース個別にサブネットを作成する方針としているためです（別記事で説明予定です）。にもかかわらず未使用のサブネットを定義しているのは、今後の何らかの作業（GUIでお試しとか）を想定したものです。
1. setting.tf
   各種リソースの設定を一元的に定義しています。
   １つのファイルに設定を集約することで、環境が増えた際にファイルコンペアで環境の差分を見やすくなります。
   設定ファイル内にnetworkやrdsなどのセクションを設けることで、設定項目のまとまりを判別しやすくしています。

# 使用方法
1. terraformとソースを配置する
   具体的な手順が知りたい場合は[別記事（ローカルでhello world）](https://zenn.dev/sway/articles/terraform_biginner_helloworld)を参照してください。
   ![init](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_00.jpg)
1. terraformの初期化処理
   initサブコマンドを実行して初期設定を行います。
   ```
   terraform.exe init
   ```
   ![init](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_01.jpg)
1. 構築内容を確認する
   planサブコマンドを実行して構築内容を確認します。
   ```
   terraform.exe plan
   ```
   ![plan](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_02.jpg)
1. 構築する
   applyサブコマンドを実行して構築します。途中で本当に構築するかの確認があるのでyesを入力します。
   ```
   terraform.exe apply
   ```
   ![apply](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_03.jpg)
   ![apply](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_04.jpg)
1. 構築結果を確認する
   正常に構築が完了するとWordPressにアクセスするURLが表示されます。セットアップの途中で使用するRDSのホスト名も表示されます。
   ![result](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_05.jpg)
1. ブラウザでアクセス
   ブラウザでアクセスするとWordPresの設定画面が表示されています。
   ![show in browser](/images/terraform_codebase_wordpress_minimal/terraform_codebase_wordpress_minimal_howtouse_06.jpg)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_codebase_.wordpress_minimal)
