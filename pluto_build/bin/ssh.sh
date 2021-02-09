#!/bin/bash
function ssh_ls {
    sftp -q -i ~/.ssh/ginger \
    $GINGER_USER@$GINGER_HOST << EOF
    ls $@
EOF
}
register 'ssh' 'ls' 'ls in ssh' ssh_ls


function ssh_cmd {
    sftp -q -i ~/.ssh/ginger \
    $GINGER_USER@$GINGER_HOST << EOF
    $@
EOF
}
register 'ssh' 'cmd' 'any commands in ssh' ssh_cmd