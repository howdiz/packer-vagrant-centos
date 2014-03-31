vagrant halt laravel
VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff
vagrant up base
vagrant ssh base
