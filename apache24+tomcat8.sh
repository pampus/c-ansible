#!/bin/sh
##########################
## Standard Command
##########################
source /var/tmp/catalogpack_vars.txt

yum update -y
pip install ansible
yum install -y git gcc openssl-devel libffi-devel
cd ~
git clone https://github.com/cloudpack/c-ansible.git
##########################
## Standard Parameter
##########################
aws_region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//g')
cat <<EOF > c-ansible/group_vars/all.yml
aws_region: "${aws_region}"
sshd: ${sshd}
EOF

##########################
## Apache Parameter
##########################
cat <<EOF > c-ansible/roles/apache24/vars/main.yml
site:
 - { domain: "www.test1.com", owner: "root", group: "root" }
 - { domain: "www.test2.co.jp", owner: "apache", group: "root" }
EOF
##########################
## Ansible Exec
##########################
/usr/local/bin/ansible-playbook c-ansible/apache24+tomcat8.yml
