#!/bin/bash


DIA=`date +"%d/%m/%Y"`
HORA=`date +"%H:%M"`

echo "Hoy es $DIA y la hora actual es $HORA!"

echo "-----------------------------------------"
echo "             MENU PRINCIPAL"
echo "-----------------------------------------"
echo "1. Equipos activos"
echo "2. Escaner de puertos"
echo "3. Info"
echo "4. Salir"
read -p "Opcion [1-4]: " op

if [ $op -eq 1 ]
then
	which ifconfig && { echo "Comando ifconfig existe..."; direccion_ip=`ifconfig |grep inet |grep -v "127.0.0.1" |awk '{print $2}'`;
			    echo "Esta es tu direccion ip: "$direccion_ip;
			    subred=`ifconfig |grep inet |grep -v "127.0.0.1" |awk '{ print $2}'|awk -F. '{print $1"."$2"."$3"."}'`;
			    echo "Esta es tu subred: "$subred;
			    }\
			|| { echo "No existe el comnado ifconfig...usando ip";
			    direccion_ip=`ip addr show |grep inet |grep -v "127.0.0.1" |awk '{ print $2}'`
			    echo "Esta es tu direccion ip: "$direccion_ip;
			    subred=`ip addr show |grep inet |grep -v "127.0.0.1" |awk '{print $2}'|awk -F. '{print $1"."$2"."$3"."}'`;
			    echo "Esta es tu subred: "$subred;
			    }
	for ip in {1..254}
	do
		ping -q -c 4 ${subred}${ip} > /dev/null
		if [ $? -eq 0 ]
		then
			echo "Host responde: " ${subred}${ip}
		fi
	done

elif [ $op -eq 2 ]
then
	direccion_ip=$1
	puertos="20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000"

	IFS=,
	for port in $puertos
	do
		timeout 1 bash -c "echo > /dev/tcp/$direccion_ip/$port > /dev/null 2>&1" &&\
		echo $direccion_ip":"$port" is open"\
		||\
		echo $direccionn_ip":"$port" is closed"
	done

elif [ $op -eq 3 ]
then
	echo "Username: $(whoami)"
	echo "Hostname: $(hostname)"
	plataform="unknown"
	if [ "$OSTYPE" == "linux-gnu" ];
	then
		plataform="linux"
	elif [ "$OSTYPE" == "darwin" ];
	then
		plataform="Mac Os"
	elif [ "$OSTYPE" == "win32" ];
	then
		plataform="Windows"
	fi
	echo "Operative system: "$plataform

elif [ $op -eq 4 ]
then
	echo "Hasta luego"
fi