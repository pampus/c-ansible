    ### Apache
    cat <<EOF > c-ansible/roles/apache24/vars/main.yml
    site:
     - { domain: "www.test1.com", owner: "root", group: "root" }
     - { domain: "www.test2.co.jp", owner: "apache", group: "root" }
    EOF
