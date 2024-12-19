#!/bin/bash
function msg_modo_de_uso {
    echo -e "Modo de uso: ./service.sh <comando>\n./service.sh start\n./service.sh rm\n./service.sh down"
}

function iniciar_servico {
    docker-compose -p atividade_asa up --build &
}

function interromper_servico {
    docker-compose -p atividade_asa down
}

# Remover as imagens dos containers
function rem_imagens {
    # Verificar se os containers existem antes de removê-los
    if docker ps -a --format '{{.Names}}' | grep -q "atividade_asa_proxy "; then
        docker rm -f atividade_asa_proxy 
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "atividade-asa01_web1_1"; then
        docker rm -f atividade_asa_web1
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "atividade-asa01_web2_1"; then
        docker rm -f atividade_asa_web2
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "atividade-asa01_dns_1"; then
        docker rm -f atividade_asa_dns
    fi

    # Remover as imagens
    docker rmi -f atividade_asa_dns
    docker rmi -f atividade_asa_proxy
    docker rmi -f atividade_asa_web1
    docker rmi -f atividade_asa_web2

}

if [ $# -ne 1 ]; then
  msg_modo_de_uso
  exit 1
fi

acao=$1

if [ "$acao" == "start" ]; then
    iniciar_servico    
elif [ "$acao" == "rm" ]; then
    rem_imagens
elif [ "$acao" == "stop" ]; then
    interromper_servico
else
    msg_modo_de_uso
fi