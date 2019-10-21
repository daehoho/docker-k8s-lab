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


help_func() {
    echo "Your Operating System : $THIS_OS"
    echo "Usage: $0 [option]"
    echo "----------- options -----------"
    echo "책의 실습 순서는 아래와 같습니다"
    echo "1. init : 스웜의 manager 역할 할당"
    echo "2. join : 스웜에 worker 등록"
    echo "3. status : 스웜의 node 상태 확인"
    echo "4. image : image 이름 변경 및 push"
    echo "5. service : 클러스터 내부의 서비스 제어"
    echo "6. scale-out : 생성된 서비스 scale out"
}


print_and_exec() {
    echo "-명령어 : $cmd"
    ``$cmd` >&1`
    echo ""
}

init_func() {
    echo "################### swarm init ###################"
    cmd="$TTY_CMD docker container exec -it manager docker swarm init"
    print_and_exec cmd
}

status_func() {
    echo "################### swarm node ###################"
    cmd="$TTY_CMD docker container exec -it manager docker node ls"
    print_and_exec cmd
}

join_func() {
    echo "################### swarm join ###################"
    echo -e "input token : "
    read token

    for ((i=1;i<=3;i++)); do
        cmd="$TTY_CMD  docker container exec -it worker0$i docker swarm join \
            --token $token manager:2377"
        echo "* worker0$i join" 
        print_and_exec cmd
    done
}

image_func() {
    echo "################### image rename ###################"
    cmd="$TTY_CMD docker image tag example/echo:latest localhost:5000/example/echo:latest"
    print_and_exec cmd

    echo "################### image push ###################"
    cmd="$TTY_CMD docker image push localhost:5000/example/echo:latest"
    print_and_exec cmd

    echo "################### image pull test ###################"
    cmd="$TTY_CMD docker container exec -it worker01 docker image pull registry:5000/example/echo:latest"
    print_and_exec cmd

    echo "################### image check ###################"
    cmd="$TTY_CMD docker container exec -it worker01 docker image ls"
    print_and_exec cmd
}

service_func() {
    echo "################### service create ###################"
    cmd="$TTY_CMD docker container exec -it manager \
        docker service create \
        --replicas 1 \
        --publish 8000:8080 \
        --name echo \
        registry:5000/example/echo:latest"
    print_and_exec cmd

    echo "################### service status ###################"
    cmd="$TTY_CMD docker container exec -it manager \
        docker service ls"
    print_and_exec cmd
}

scale-out_func() {
    echo -e "input replicas count: "
    read count

    echo "################### scale out ($count) ###################"
    cmd="$TTY_CMD docker container exec -it manager \
        docker service scale echo=${count}" 
    print_and_exec cmd

    echo "################### node status ###################"
    cmd="$TTY_CMD docker container exec -it manager \
        docker service ps echo"
    print_and_exec cmd
}


case ${args[0]} in
    help)
        help_func
        ;;
    init)
        init_func
        ;;
    status)
        status_func
        ;;
    join)
        join_func
        ;;
    image)
        image_func 
        ;;
    service)
        service_func
        ;;
    scale-out)
       scale-out_func 
        ;;
    *)
        echo "지원하지 않는 명령어입니다."
        echo "$0 help 를 입력하여 명령어를 확인하세요"
        exit 1
        ;;
esac
