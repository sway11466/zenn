---
title: "ALB+EC2+AuroraでMattermost - Terraformのきほんと応用"
emoji: "🏰"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["terraform", "AWS", "Mattermost"]
published: false
---
TerraformでAWSを構築する際のひな形となるコードを公開しています。個別のコンポーネントではなくコードベース全体です。
Terraform関連の他の記事は「[Terraformのきほんと応用](https://zenn.dev/sway/articles/terraform_index_list)」からどうぞ。

# 特徴
ALB＋EC2＋Aurora＋S3の構成による実践的なmattermost環境です。システム構成の特徴は以下の通り沢山ありますが、細かい説明はしていません。今後、１つ１つ記事にしていきます。
- ドメイン名＆SSLによるアクセス
   - DNSレコードの作成とALBへの割り当て
   - ACMによるSSL証明書の作成
- EC2はプライベートサブネットに配置
   - インターネットからのアクセスはALB経由
   - インターネットへのアクセスはNatGW(Nat GateWay)経由
   - プライベートセグメントへのセッションマネージャー接続
- データはAurora(mysql)とs3に保管
- EC2はオートヒーリング
   - 起動テンプレートとAutoScalingグループによる管理
   - ALBからAutoScalingグループへの分散
- 1カ月動かすと2.5万円ぐらいかかります
   - EC2とAuroraは最小構成
   - 3AZで動かしているNatGWが費用の大半で2万円／月ぐらいかかります
   - [AWS Pricing Calculatorで表示](https://calculator.aws/#/estimate?id=9243b6b8f4d63ebafbcc14a5d5762875ed35eaa0)

# システム構成
publicサブネットにはALBとNatGWのみという、プライベートなチャットを使いたい組織が好みそうな構成です。
![system structure](/images/terraform_codebase_mattermost/terraform_codebase_mattermost_structure.png)

# ソース構成
フラットな構成でnetwork系とmattermost系のソースを分けています。また、ソースを読むのに必要な知識を少なくするため以下の機能を使用していません。
- for_each文
- ワークスペース
![source list](/images/terraform_codebase_mattermost/terraform_codebase_mattermost_code.png)

# 使用方法
1. ホストゾーンIDとドメイン名を変更する
   設定ファイルのホストゾーンIDとドメイン名を変更します。
   ```hcl:setting.tf
   locals {
      network = {
         zone_id = "Z099999999GHIJKLMNOPQ"
      }
      mattermost = {
         domain_name = "mattermost.change-domain.com"
     }
   }
   ```
1. terraformで構築する
   特別な手順は不要でterraformコマンドを順に実行するのみです。Auroraの構築があるため5分～10分程度かかります。terraform完了後もmattermostサーバーの構築に5～10分ぐらいかかります。
   具体的な手順が知りたい場合は[別記事（ローカルでhello world）](https://zenn.dev/sway/articles/terraform_biginner_helloworld)を参照してください。
   ```
   terraform.exe init
   terraform.exe plan
   terraform.exe apply
   ```
1. ブラウザでアクセス
   ブラウザでアクセスするとmattermostの初期画面が表示されています。
   ![show in browser](/images/terraform_codebase_mattermost/terraform_codebase_mattermost_howto.png)

# サンプルコード
この記事で作成したコードはgithub上に公開しています。
@[card](https://github.com/sway11466/zenn/tree/main/sample_codes/terraform_codebase_mattermost_structure)
