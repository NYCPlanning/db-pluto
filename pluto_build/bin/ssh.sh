#!/bin/bash
set -e

function _ls {
    sftp -q -i ~/.ssh/ginger \
    $GINGER_USER@$GINGER_HOST << EOF
    ls $@
EOF
}
register 'ssh' 'ls' 'ls in ssh' _ls


function _cmd {
    sftp -q -i ~/.ssh/ginger \
    $GINGER_USER@$GINGER_HOST << EOF
    $@
EOF
}
register 'ssh' 'cmd' 'any commands in ssh' _cmd