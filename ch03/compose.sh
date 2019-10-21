#!/bin/bash

cmd="docker-compose \
    -f docker-compose.yml \
    -f docker-manager-compose.yml \
    -f docker-worker-compose.yml "
up_cmd="$cmd up -d"
down_cmd="$cmd down"

if [ "$#" -lt 1 ]; then
    echo "파라미터를 입력해주세요."
    exit 1
elif [ "$#" -gt 1 ]; then
    echo "파라미터가 너무 많습니다. "
    exit 1
fi
args=("$@")

case ${args[0]} in
    up)
        echo "################### compose up ###################"
        echo "COMMAND : $up_cmd"
        `$up_cmd` >&1
        ;;
    down)
        echo "################### compose down ###################"
        echo "COMMAND : $down_cmd"
        `$down_cmd` >&1
        ;;
    *)
        echo "지원하지 않는 명령어입니다."
        exit 1
        ;;
esac
