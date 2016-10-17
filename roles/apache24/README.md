# Execute Command
    ### Apache
    cat <<EOF > c-ansible/roles/apache24/vars/main.yml
    site:
     - { domain: "www.test1.com", owner: "root", group: "root" }
     - { domain: "www.test2.co.jp", owner: "apache", group: "root" }
    EOF

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

## <VirtualhostName>.conf
|Parameter|Require|Default|Changed|
| ------- |:-----:|-------|:-----:|
|ServerName   |       |www.test1.com                                 |o      |
|DocumentRoot |       |/var/www/www.test1.com/                       |o      |
|CustomLog    |       |logs/{{ item.domain }}-access_log combined-elb|o      |
|ErrorLog     |       |logs/{{ item.domain }}-error_log              |o      |

