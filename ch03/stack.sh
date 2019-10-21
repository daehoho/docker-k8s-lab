#!/bin/bash

CHECK_OS="`uname -s`"

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

if [[ "$CHECK_OS" = "Darwin"* ]]; then     
	THIS_OS="MAC" 
	TTY_CMD=""
elif [[ "$CHECK_OS" = "Linux"* ]]; then     
	THIS_OS="LINUX" 
	TTY_CMD=""
elif [[ "$CHECK_OS" = "MINGW32"* ]]; then     
	THIS_OS="WIN" 
	TTY_CMD="winpty"
elif [[ "$CHECK_OS" = "MINGW64"* ]]; then 
	THIS_OS="WIN" 
	TTY_CMD="winpty"
elif [[ "$CHECK_OS" = "CYGWIN"* ]]; then 
	THIS_OS="WIN"     
	TTY_CMD="winpty"
fi

function help_func {
    echo "Your Operation System : $THIS_OS"
    echo "Usage: $0 [option]"
    echo "----------- options -----------"
    echo "책의 실습 순서는 아래와 같습니다"
    echo "1. network : overlay 네트워크 생성"
    echo "2. deploy : stack을 배포"
    echo "3. list : stack 서비스 목록 확인"
    echo "4. ps : stack에 배포된 컨테이너 목록"
    echo "5. visual : stack에 visualizer를 배포"
    echo "6. rm : 배포된 서비스를 스택째로 삭제 "
    echo "7. ingress-deploy : haproxy ingress 배포 "
}

function print_and_exec {
    echo "- 명령어 : $1"
    ``$1` >&1`
    echo ""
}

function network_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker network create \
        --driver=overlay \
        --attachable ch03"
    print_and_exec "$cmd"
}

function deploy_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker stack deploy -c \
        /stack/ch03-webapi.yml echo" 
    print_and_exec "$cmd"
}

function list_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker stack services" 
    print_and_exec "$cmd"
}

function ps_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker stack ps echo" 
    print_and_exec "$cmd"
}

function visual_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker stack deploy -c \
        /stack/visualizer.yml visualizer" 
    print_and_exec "$cmd"
}

function rm_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker stack rm echo" 
    print_and_exec "$cmd"
}

function ingress-deploy_func {
    cmd="$TTY_CMD docker container exec -it manager \
        docker stack deploy -c \
        /stack/ch03-ingress.yml ingress" 
    print_and_exec "$cmd"
}


case ${args[0]} in
    help)
        help_func
        ;;
    network)
        network_func
        ;;
    deploy)
        deploy_func
        ;;
    list)
        list_func 
        ;;
    ps)
        ps_func 
        ;;
    visual)
        visual_func 
        ;;
    rm)
        rm_func
        ;;
    ingress-deploy)
        ingress-deploy_func
        ;;
    *)
        echo "지원하지 않는 명령어입니다."
        echo "$0 help 를 입력하여 명령어를 확인하세요"
        exit 1
        ;;
esac
