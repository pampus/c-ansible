# 前提
Supprt OS : Amazon Linux AMI 2016.09.0

# 使い方
UserDataに以下のコードを挿入し実行してください。
CFn内のUserDataでも可です。

## UserData Version
    #!/bin/sh
    yum install -y git
    git clone https://github.com/cloudpack/c-ansible.git
    source /var/tmp/catalogpack_vars.txt
    
    sh c-ansible/xxx.sh

# 必要なIAMロール権限
- AmazonEC2RoleforSSM
- CloudWatchLogsFullAccess

# ルール
## 各Role追加時には以下を考慮し追加してください
- ログファイルが出力される場合
-- logrotateのconfファイルを配置する
-- CloudWatch Logs Agentのconfファイルを配置する
- プロセスがある場合
-- monitのconfを配置する

# CloudFormationとの線引
疎結合性を高めるために以下の線引で開発する
## Ansible側
* xxx.ymlを作成の際に、xxx.shも作成する
* xxx.shにはuserdataで実行して欲しい処理を記載する
* CloudFormation側のuserdataの定義で、xxx.shをcurlでDLし、ローカル実行させる
* CloudFormationから変数を渡したい場合は、/var/tmp/catalogpack_vars.txtに変数を埋め込んでもらう
* xxx.shの冒頭で/var/tmp/catalogpack_vars.txtを読み込み、CloudFormationから変数を受け取る
