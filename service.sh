#!/usr/bin/bash

function msg_modo_de_uso {
    echo -e "Modo de uso: ./service.sh <comando>\n./service.sh start\n./service.sh rm\n./service.sh down"
}

function iniciar_servico {
    docker-compose -p atividadeasa up --build &
}

function interromper_servico {
    docker-compose -p atividadeasa down
}

# Remover as imagens dos containers
function rem_imagens {
    # Verificar se os containers existem antes de removê-los
    if docker ps -a --format '{{.Names}}' | grep -q "atividadeasa_proxy"; then
        docker rm -f atividadeasa_proxy
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "atividadeasa_web1"; then
        docker rm -f atividadeasa_web1
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "atividadeasa_web2"; then
        docker rm -f atividadeasa_web2
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "atividadeasa_dns"; then
        docker rm -f atividadeasa_dns
    fi

    # Remover as imagens
    docker rmi -f atividadeasa_dns
    docker rmi -f atividadeasa_proxy
    docker rmi -f atividadeasa_web1
    docker rmi -f atividadeasa_dns

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
