# 実行方法
- リモートからの実行
```bash
ansible-playbook -i "(IPアドレス)," common.yml -e (追加オプション) -e (追加オプション)
```
- ローカルでの実行
```bash
ansible-playbook -i "localhost," -c local common.yml -e (追加オプション) -e (追加オプション)
```

# 標準仕様

[initialize.yml](https://github.com/cloudpack/c-ansible/blob/master/roles/common/tasks/initialize.yml)
- Timezone設定
  - Asia/Tokyoのみ
- motd設定
- NTP Slewモード設定
- bashヒストリサイズ、タイムフォーマット設定
- ログローテーション
  - logrotateで31世代保管（日次）
    - 対象
      - /var/log/cron
      - /var/log/maillog
      - /var/log/messages
      - /var/log/secure
      - /var/log/speeler
      - /var/log/monit
- Swapファイル作成/マウント
  - 2GB

[command.yml](https://github.com/cloudpack/c-ansible/blob/master/roles/common/tasks/command.yml)
- 必要パッケージのインストール
- 不要パッケージのアンインストール
- monit設定

[aws.yml](tasks/aws.yml)
- SystemMangerエージェント インストール
- CodeDeployエージェント インストール
- Inspectorエージェント インストール


# オプションによる対応
## リージョン指定
### 概要
- リージョンの指定可能
- 東京リージョンの場合は省略可

### 使用方法
- コマンド引数による対応
  - `-e aws_region=us-east-1`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
aws_region: us-east-1
EOF
```

## ログの外部保存
### 概要
- Cloudwatch Logs エージェントのインストール
- Cloudwatch Logsによるログの外部保存

[aws.yml](https://github.com/cloudpack/c-ansible/blob/master/roles/common/tasks/aws.yml)
### 対象
- /var/log/messages
- /var/log/cron
- /var/log/maillog
- /var/log/secure
- /var/log/yum.log
- /var/log/cloud-init.log
- /var/log/monit
- /var/log/amazon/ssm/amazon-ssm-agent.log

### 使用方法
- コマンド引数による対応
  - `-e awslogs=enable`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
awslogs: enable
EOF
```

## Datadog対応
### 概要
- Datadogエージェントのインストール

[datadog.yml](https://github.com/cloudpack/c-ansible/blob/master/roles/common/tasks/datadog.yml)

### 使用方法
- コマンド引数による対応
  - `-e dd_api_key=（DatadogのAPI Key)`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
dd_api_key: （DatadogのAPI Key)
EOF
```

## sshd停止
### 概要
- sshdサービスを停止する

[initialize.yml](https://github.com/cloudpack/c-ansible/blob/master/roles/common/tasks/initialize.yml)

### 使用方法
- コマンド引数による対応
  - `-e sshd=stopeed`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
sshd: stopped
EOF
```
