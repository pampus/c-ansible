# 利用する時に実行して欲しいコマンド
    ### Apache
    cat <<EOF > c-ansible/roles/apache24/vars/main.yml
    site:
     - { domain: "www.test1.com", owner: "root", group: "root" }
     - { domain: "www.test2.co.jp", owner: "apache", group: "root" }
    EOF

# 仕様
* 概要
    * yumでinstallした時と構成は同じ
    * デフォルトからの差分と代表的な設定値は[Default Parameter for Apache]に記載
* 複数のVirtualHostを生成
    * [c-ansible/roles/apache24/vars/main.yml]に変数を定義すると、自動的にVirtualHostのconfやdirectoryを作成してくれる
* ログの外出しとローテーション：accesslog / errorlog (VirtualHostのログ含む)
    * logrotateで31世代保管（日次）
    * CloudWatchLogs AgentでリアルタイムでCloudWatchLogsに転送
* メトリクスの外出し：Apacheのメトリクス（実装予定。しばし待たれよ）
    * MaxClient数などをcollectdを経由し、CloudWatchに飛ばす予定。その値を元に自動制御も検討中。
* 自動復旧（実装予定。しばし待たれよ）
    * 障害検知時にmonit(1分間隔)でrestart。5分以上復旧しない場合はCloudWatchで自動stop/start。
    * 障害判定条件 => process down / etc...

# Default Parameter for Apache
## httpd.conf
|Parameter|Require|Default|Changed|
| ------- |:-----:|-------|:-----:|
|Listen   |       |80     |x      |
|User     |       |apache |x      |
|Group    |       |apache |x      |
|ServerTokens|       |ProductOnly|x      |
|DocumentRoot(Default)|       |/var/www/html|x      |
|AllowOverride(/var/www/)|       |All|x      |
|DirectoryIndex|       |index.html index.htm index.php index.cgi|x      |
|ErrorLog|       |logs/error_log|x      |
|LogFormat|       |"%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined-elb|x      |
|CustomLog|       |"logs/access_log" combined|x      |
|ScriptAlias|       |/cgi-bin/ "/var/www/cgi-bin/"|x      |
|AddDefaultCharset|       |UTF-8|x      |
|TraceEnable|       |Off|x      |
|ExtendedStatus|       |On|x      |
|IncludeOptional|       |conf.d/*.conf|x      |
||       ||x      |

## VirtualhostName.conf
|Parameter|Require|Default|Changed|
| ------- |:-----:|-------|:-----:|
|ServerName   |       |www.test1.com                                 |o      |
|DocumentRoot |       |/var/www/www.test1.com/                       |o      |
|CustomLog    |       |logs/www.test1.com-access_log combined-elb|o      |
|ErrorLog     |       |logs/www.test1.com-error_log              |o      |

