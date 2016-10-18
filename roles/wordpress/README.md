# 利用する時に実行して欲しいコマンド
    ### wordpress
    cat <<EOF > c-ansible/roles/wordpress/vars/main.yml
    wp_db_name: wordpress
    wp_db_user: wordpress
    wp_db_password: wordpress
    wp_dir: /var/www/html
    mysql_host: localhost
    mysql_port: 3306
    auto_up_disable: false
    core_update_level: true
    EOF

# 仕様
## 概要
* ja.wordpress.orgより最新版のWordpressをダウンロード
* DocumentRoot(/var/www/html)にダウンロードしたWordpressを配置、解凍
* wp-config.phpを書き換え
* デフォルトからの差分と代表的な設定値は[Default Parameter for Wordpress]に記載


# Default Parameter for Wordpress
## wp-config.php
|Parameter|Require|Default|Changed|
| ------- |:-----:|-------|:-----:|
|wp_db_name|o     |wordpress|o      |
|wp_db_user|o     |wordpress|o      |
|wp_db_password|o |wordpress|o      |
|wp_dir   |       |/var/www/html|-      |
|mysql_host|o     |localhost|o      |
|mysql_port|       |3306|o      |
|auto_up_disable|       |false   |-      |
|core_update_level|       |true  |-      |
