#!/bin/bash

# ssh接続用引数(-i *****.pem user@server)
SSH_PARAM=ubuntu

ARG=${1//\\//} # パスの区切り文字を置換(\⇒/)

if [ -d "$1" ]; then
    # 引数がディレクトリの場合、圧縮してからアップロード(解凍も行う)
    UPD_PATH=${ARG%/} # パスの最後の'/'を削除(あってもなくても動作するように)
    DIR_NAME=${UPD_PATH##*/} # パスの最後のディレクトリ名

    echo "Upload '$UPD_PATH' directory to '~/$DIR_NAME'"
    tar -zcf - -C "$UPD_PATH/.." $DIR_NAME | ssh $SSH_PARAM "tar zxf - -C ~/"
else
    # 引数がファイルの場合、sshにパイプで渡してそのまま保存
    echo "Upload '$ARG' file to '~/${ARG##*/}'"
    cat $1 | ssh $SSH_PARAM "cat > ~/${ARG##*/}"
fi
