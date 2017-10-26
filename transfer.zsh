#!/usr/bin/env zsh

transfer()
{
    usage="Usage: transfer /path/to/file"
    if [ $# -eq 0 ]
    then
        echo -e "No arguments specified. $usage"
        return 1
    fi
    if [ $# -gt 1 ]
    then
        echo -e "More than one argument specified. $usage"
        return 1
    fi
    if [ ! -f "$1" ]
    then
        x=$(printf '%q' "$1")
        echo "File $x does not exist."
        return 1
    fi
    tmpfile=$( mktemp -t transferXXX )
    if tty -s
    then
        basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
        curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
    fi
    printf '%b\n' "$(cat $tmpfile)"
    rm -f $tmpfile
}

transfer "$@"
