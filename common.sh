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
EOF

##########################
## Ansible Exec
##########################
/usr/local/bin/ansible-playbook -i "localhost," -c local c-ansible/common.yml\
  -e aws_region=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed -e 's/.$//g')
  -e awslogs=enable
