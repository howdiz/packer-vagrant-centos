vagrant halt base
VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff
vagrant up laravel
vagrant ssh laravel
