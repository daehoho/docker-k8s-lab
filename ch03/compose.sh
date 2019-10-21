#!/bin/bash

cmd="docker-compose \
    -f docker-compose.yml \
    -f docker-manager-compose.yml \
    -f docker-worker-compose.yml "
up_cmd="$cmd up -d"
down_cmd="$cmd down"

if [ "$#" -lt 1 ]; then
    echo "파라미터를 입력해주세요."
    echo "$0 help 를 입력하여 명령어를 확인하세요"
    exit 1
elif [ "$#" -gt 1 ]; then
    echo "파라미터가 너무 많습니다. "
    echo "$0 help 를 입력하여 명령어를 확인하세요"
    exit 1
fi
args=("$@")

help_func() {
    echo "Usage: $0 [option]"
    echo "----------- options -----------"
    echo "up : swarm을 위한 컨테이너들 daemon으로 띄웁니다."
    echo "down : 컨테이너들을 종료합니다."
}

print_and_exec() {
    echo "-명령어 : $cmd"
    ``$cmd` >&1`
    echo ""
}

up_func() {
    echo "################### compose up ###################"
    print_and_exec up_cmd
}

down_func() {
    echo "################### compose down ###################"
    print_and_exec down_cmd
}

case ${args[0]} in
    help)
        help_func
        ;;
    up)
        up_func
        ;;
    down)
        down_func
        ;;
    *)
        echo "지원하지 않는 명령어입니다."
        exit 1
        ;;
esac
