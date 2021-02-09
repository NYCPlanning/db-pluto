#!/bin/bash
function ssh_ls {
    sftp -q -i ~/.ssh/ginger \
    $GINGER_USER@$GINGER_HOST << EOF
    ls $@
EOF
}


function ssh_cmd {
    sftp -q -i ~/.ssh/ginger \
    $GINGER_USER@$GINGER_HOST << EOF
    $@
EOF
}