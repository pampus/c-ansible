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
## PHP Parameter
##########################
cat <<EOF > c-ansible/roles/php70-fpm/vars/main.yml
timezone: ${timezone}
EOF
##########################
## Ansible Exec
##########################
/usr/local/bin/ansible-playbook c-ansible/nginx110+php70-fpm.yml
