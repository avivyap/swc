#!/bin/bash

# swc, Author avivyap (@avivyap)

echo -ne  "\e[32m Hecho por\e[0m"

echo -e "\e[33m Avivyap\e[0m"

sleep 0.5

echo -ne "\e[32m Instagram\e[0m"

sleep 0.5

echo -e "\e[33m @avivyap\e[0m"

sleep 1

# Definir colores
yellowColour="\e[33m"
greenColour="\e[32m"
blueColour="\e[34m"
endColour="\e[0m"

# Listar todas las tarjetas de red disponibles numeradas y coloreadas
echo -e "${greenColour}[+] ${blueColour}Tarjetas de red disponibles:${endColour}"
ip -o link show | awk -F': ' '{print NR".", "\033[1m"$2"\033[0m"}'
echo -e "${greenColour}[-]${endColour}"

sleep 1

# Preguntar por el número de la tarjeta de red a utilizar
echo -e "${greenColour}[+]${endColour} Por favor ingresa el ${yellowColour}número${endColour} de la tarjeta de red que deseas configurar: "
read opcion

# Obtener el nombre de la tarjeta de red seleccionada
nombre=$(ip -o link show | awk -F': ' -v opcion="$opcion" 'NR==opcion {print $2}')

# Desactivar la interfaz seleccionada
ifconfig $nombre down

sleep 2

# Solicitar el nuevo nombre para la interfaz
echo -e "${greenColour}[+]${endColour} ¿Qué ${yellowColour}nombre${endColour} le quieres poner a la tarjeta de red?"
read nuevo_nombre

# Cambiar el nombre de la interfaz
ip link set dev $nombre name $nuevo_nombre

sleep 2

# Cambiar la dirección MAC de la interfaz
macchanger --mac=00:1c:3f:5a:2b:cc $nuevo_nombre

sleep 2

# Activar la interfaz con el nuevo nombre
ifconfig $nuevo_nombre up

echo -e "${greenColour}[+]${endColour} Configuración completada."
