# 実行方法
- リモートからの実行
```bash
ansible-playbook -i "(IPアドレス)," wordpress.yml -e (追加オプション) -e (追加オプション)
```
- ローカルでの実行
```bash
ansible-playbook -i "localhost," -c local wordpress.yml -e (追加オプション) -e (追加オプション)
```

# 標準仕様
## 依存関係
[common](https://github.com/cloudpack/c-ansible/tree/master/roles/common)、[apache24+PHP](https://github.com/cloudpack/c-ansible/tree/master/roles/apache24)  が自動適用される

## 構成
- ja.wordpress.orgより最新版のWordpressをダウンロード
- DocumentRoot(/var/www/html/wordpress)にダウンロードしたWordpressを配置、解凍
- データベース生成
  - ローカルにmysql-serverをインストール
  - リモート(RDS)にも対応

## パラメータ
- デフォルト
  - [defaults/main.yml](https://github.com/cloudpack/c-ansible/blob/master/roles/wordpress/defaults/main.yml)

- オプションで変更可能な値

|Parameter|Default|Remarks|
| ------- |:-----:|-------|
|wp_db_name|wordpress|生成する(もしくは生成済みの)WordPressDB名|
|wp_db_user|wordpress|生成するWordPress用DBユーザ名|
|wp_db_password|wordpress|生成するWordPress用DBユーザのパスワード|
|wp_dir   |/var/www/html|コンテンツの保存先(wp_dir/wordpress)|
|mysql_host|localhost|リモートのDBサーバの場合は、ホスト名orIPアドレスを指定|
|mysql_port|3306||
|mysql_user|-|リモートのDBに接続するユーザ名|
|mysql_password|-|リモートのDBに接続するパスワード|
|auto_up_disable|false   |-      |
|core_update_level|true  |-      |
