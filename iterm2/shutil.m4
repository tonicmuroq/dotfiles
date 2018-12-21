divert(-1)

define(`dlast', `substr($1, 0, eval(len($1) - 1))')
define(`env', `dlast(esyscmd(printenv $1))')
define(`pycmd', `dlast(esyscmd(`python <<EOF
$1
EOF'))')
define(`jsontext', `pycmd(import json; print(json.dumps("$1")))')

divert(0)dnl
