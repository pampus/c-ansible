# 実行方法
- リモートからの実行
```bash
ansible-playbook -i "(IPアドレス)," nginx.yml -e (追加オプション) -e (追加オプション)
```
- ローカルでの実行
```bash
ansible-playbook -i "localhost," -c local nginx.yml -e (追加オプション) -e (追加オプション)
```

# 標準仕様
## 依存関係
[common](https://github.com/cloudpack/c-ansible/tree/master/roles/common) が自動適用される

## 構成
- yumでの通常インストール

## Nginx設定
- [conf.d/default.conf](templates/default.conf.j2)
- [conf.d/(VirtualhostName).conf](templates/virtualhost.conf.j2)

## ログローテーション
- logrotateで31世代保管（日次）
- 対象
  - /var/log/nginx/*log

## 自動復旧
- monitによる監視/自動復旧を実装
  - 1分間隔で5回接続不可の場合、サービスの再起動
- 障害判定条件
  - プロセスチェック
  - ローカルでTCP/80のチェック

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

## VirtualHost対応
### 概要
- VirtualhostごとのConfig生成
- VirtualhostごとのRootDiretory生成

### 使用方法
- コマンド引数による対応
  - `-e '{ "site":[{"domain":"www.test1.com", "owner":"nginx", "group":"nginx"},{"domain":"www.test2.co.jp", "owner":"nginx", "group":"nginx"}]}'`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
site:
  - { domain: "www.test1.com", owner: "nginx", group: "nginx" }
  - { domain: "www.test2.co.jp", owner: "nginx", group: "nginx" }
EOF
```

## ログの外部保存
### 概要
- Cloudwatch Logsによるログの外部保存
- 対象
  - /var/log/nginx/access.log
  - /var/log/nginx/error.log
  - /var/log/nginx/`VirtualhostName`-access_log
  - /var/log/nginx/`VirtualhostName`-error_log

### 使用方法
- コマンド引数による対応
  - `-e awslogs=enable`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
awslogs: enable
EOF
```

## メトリックスの取得
### 概要
- Datadogによるメトリックスの取得
  - http://docs.datadoghq.com/integrations/nginx/
  
### 使用方法
- コマンド引数による対応
  - `-e dd_api_key=（DatadogのAPI Key)`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
dd_api_key: （DatadogのAPI Key)
EOF
```

## PHP対応
### 概要
- PHP7.0実行環境（パッケージ）のインストール
- 設定ファイルの配備
- PHP-FPM7.0環境のインストール、起動

### 使用方法
- コマンド引数による対応
  - `-e ｐｈｐ=enable`
  - タイムゾーンを変更する場合（デフォルトはAsia/Tokyo）
    - `-e timezone=XXX/XXX`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
php: enable
## タイムゾーンを変更する場合
# timezone: XXX/XXX
EOF
```
### Nginx設定
- [conf.d/default.conf](templates/default-php.conf.j2)
- [conf.d/(VirtualhostName).conf](templates/virtualhost-php.conf.j2)

### ログローテーション
- logrotateで31世代保管（日次）
- 対象
  - /var/log/php-fpm/*log

### 自動復旧
- monitによるphp-fpmの監視/自動復旧を実装
  - 障害時に、サービスの再起動
- 障害判定条件
  - プロセスチェック

### ログの外部保存
- Cloudwatch Logsによるログの外部保存
- 対象
  - /var/log/php-fpm/error.log
  
## Tomcat対応
### 概要
- Tomcat8実行環境（パッケージ）のインストール

### 使用方法
- コマンド引数による対応
  - `-e tomcat=enable`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
tomcat: enable
EOF
```
### Nginx設定
- 変更なし

### ログローテーション
- logrotateで31世代保管（日次）
- 対象
  - /var/log/tomcat8/catalina.out

### 自動復旧
- monitによるtomcat8の監視/自動復旧を実装
  - 1分間隔で5回接続不可の場合、サービスの再起動
- 障害判定条件
  - プロセスチェック
  - ローカルでTCP/8080のチェック
  
### ログの外部保存
- Cloudwatch Logsによるログの外部保存
- 対象
  - /var/log/tomcat8/catalina.out
