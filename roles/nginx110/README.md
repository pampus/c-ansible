    ### Nginx
    cat <<EOF > c-ansible/roles/nginx110/vars/main.yml
    site:
     - { domain: "www.test1.com", owner: "root", group: "root" }
     - { domain: "www.test2.co.jp", owner: "nginx", group: "root" }
    EOF
