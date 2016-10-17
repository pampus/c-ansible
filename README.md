# 前提
Supprt OS : Amazon Linux AMI 2016.09.0

# 使い方
UserDataに以下のコードを挿入し実行してください。
CFn内のUserDataでも可です。

## UserData Version
    #!/bin/sh
    yum update -y
    pip install ansible
    yum install -y git gcc openssl-devel libffi-devel

    cd ~
    git clone https://github.com/shogomuranushi/c-ansible.git
    cat <<EOF > c-ansible/group_vars/all.yml
      aws_region: "ap-northeast-1"
      sshd: enabled
    EOF
    
    /usr/local/bin/ansible-playbook c-ansible/xxx.yml

# 必要なIAMロール権限
- AmazonEC2RoleforSSM
- CloudWatchLogsFullAccess

# ルール
## 各Role追加時には以下を考慮し追加してください
- ログファイルが出力される場合
-- logrotateのconfファイルを配置する
-- CloudWatch Logs Agentのconfファイルを配置する
- プロセスがある場合
-- monitのconfを配置する
