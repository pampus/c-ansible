# 実行方法
- リモートからの実行
```bash
ansible-playbook -i "(IPアドレス)," apache24.yml -e (追加オプション) -e (追加オプション)
```
- ローカルでの実行
```bash
ansible-playbook -i "localhost," -c local apache24.yml -e (追加オプション) -e (追加オプション)
```

# 標準仕様
## 依存関係
[common](https://github.com/cloudpack/c-ansible/tree/master/roles/common) が自動適用される

## 構成
- yumでの通常インストール

## Apache設定
- デフォルトからの差分と代表的な設定値
### httpd.conf
|Parameter|Value|Changeable?|
| ------- |-------|:-----:|
|Listen   |80     |x      |
|User     |apache |x      |
|Group    |apache |x      |
|ServerTokens|ProductOnly|x      |
|DocumentRoot(Default)|/var/www/html|x      |
|AllowOverride(/var/www/)|All|x      |
|DirectoryIndex|index.html index.htm index.php index.cgi|x      |
|ErrorLog|logs/error_log|x      |
|LogFormat|"%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined-elb|x      |
|CustomLog|"logs/access_log" combined|x      |
|ScriptAlias|/cgi-bin/ "/var/www/cgi-bin/"|x      |
|AddDefaultCharset|UTF-8|x      |
|TraceEnable|Off|x      |
|ExtendedStatus|On|x      |
|IncludeOptional|conf.d/*.conf|x      |

### (VirtualhostName).conf
|Parameter|Value|Changeable?|
| ------- |-------|:-----:|
|ServerName   |`VirtualhostName`                             |x      |
|DocumentRoot |/var/www/`VirtualhostName`/                   |x      |
|CustomLog    |logs/`VirtualhostName`-access_log combined-elb|x      |
|ErrorLog     |`VirtualhostName`-error_log                   |x      |

## ログローテーション
- logrotateで31世代保管（日次）
- 対象
  - /var/log/httpd/access_log
  - /var/log/httpd/error_log
  - /var/log/httpd/`VirtualhostName`-access_log
  - /var/log/httpd/`VirtualhostName`-error_log

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
  - `-e '{ "site":[{"domain":"www.test1.com", "owner":"apache", "group":"apache"},{"domain":"www.test2.co.jp", "owner":"apache", "group":"apache"}]}'`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
site:
  - { domain: "www.test1.com", owner: "apache", group: "apache" }
  - { domain: "www.test2.co.jp", owner: "apache", group: "apache" }
EOF
```

## ログの外部保存
### 概要
- Cloudwatch Logsによるログの外部保存
- 対象
  - /var/log/httpd/access_log
  - /var/log/httpd/error_log
  - /var/log/httpd/`VirtualhostName`-access_log
  - /var/log/httpd/`VirtualhostName`-error_log

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
  - http://docs.datadoghq.com/integrations/apache/
  
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

### 使用方法
- コマンド引数による対応
  - `-e ｐｈｐ=enable`- タイムゾーンを変更する場合（デフォルトはAsia/Tokyo）
    - `-e timezone=XXX/XXX`
- ファイルへの変数記載
```bash
cat <<EOF > c-ansible/group_vars/all.yml
php: enable
## タイムゾーンを変更する場合
# timezone: XXX/XXX
EOF
```

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
### Apache設定
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

