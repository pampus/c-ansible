# Prerequisites
## Supprt OS
- Amazon Linux

# Usage
UserDataに以下のようなコードを挿入し実行してください。

    #!/bin/sh
    yum update -y
    yum install -y git gcc openssl-devel libffi-devel
    pip install ansible
    git clone https://github.com/cloudpack/c-ansible.git
    /usr/local/bin/ansible-playbook -i "localhost," -c local c-ansible/common.yml\
      -e aws_region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//g') \
      -e awslogs=enable

# Playbook
- [common](https://github.com/cloudpack/c-ansible/tree/master/roles/common)
  - 標準的な設定
- [apache24](https://github.com/cloudpack/c-ansible/tree/master/roles/apache24)
  - Apache2.4
  - PHP、Tomcatにも対応
- [nginx](https://github.com/cloudpack/c-ansible/tree/master/roles/nginx)
  - Nginx
  - PHP、Tomcatにも対応
- [wordpress](https://github.com/cloudpack/c-ansible/tree/master/roles/wordpress)

# IAM Role
### EC2インスタンスに必要なIAMロール権限
- AmazonEC2RoleforSSM
- CloudWatchLogsFullAccess

