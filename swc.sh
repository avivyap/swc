#!/bin/bash

# swc, Autor: avivyap (@avivyap)

echo -e "\e[93mHecho por\e[0m"
echo -e "\e[93mAvivyap\e[0m"
sleep 0.5
echo -e "\e[93mInstagram\e[0m"
sleep 0.5
echo -e "\e[93m@avivyap\e[0m"
sleep 1

# Definir colores
yellowColour="\e[93m"
purpleColour="\e[95m"
endColour="\e[0m"

# Verifica si el usuario es root
echo -e "${purpleColour}[+]${endColour} Comprobando permisos..."
sleep 1
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

echo -e "${purpleColour}[+]${endColour} Comprobando herramientas necesarias..."
sleep 1

# Verifica si macchanger está instalado
if ! command -v macchanger &> /dev/null; then
    echo -e "${purpleColour}[!]${endColour} macchanger no está instalado. Instalándolo..."
    sleep 1
    apt update && apt install -y macchanger
    if ! command -v macchanger &> /dev/null; then
        echo -e "${purpleColour}[!]${endColour} Error al instalar macchanger. Intenta instalarlo manualmente."
        exit 1
    fi
    echo -e "${purpleColour}[+]${endColour} macchanger instalado con éxito."
sleep 1
fi

# Listar todas las tarjetas de red disponibles numeradas y coloreadas
echo -e "${purpleColour}[+] ${endColour}${yellowColour}Tarjetas de red disponibles:${endColour}"
ip -o link show | awk -F': ' '{print NR".", "\033[1m"$2"\033[0m"}'
echo -e "${purpleColour}[-]${endColour}"

sleep 1

# Preguntar por el número de la tarjeta de red a utilizar
echo -e "${purpleColour}[+]${endColour} Por favor ingresa el ${yellowColour}número${endColour} de la tarjeta de red que deseas configurar: "
read opcion

# Obtener el nombre de la tarjeta de red seleccionada
INTERFACE=$(ip -o link show | awk -F': ' -v opcion="$opcion" 'NR==opcion {print $2}')

if [[ -z "$INTERFACE" ]]; then
    echo "Número de interfaz no válido." >&2
    exit 1
fi

# Guardar MAC original
ORIGINAL_MAC=$(ip link show "$INTERFACE" | awk '/ether/ {print $2}')

# Nueva MAC fija del script
NEW_MAC="00:1c:3f:5a:2b:cc"

echo -e "${purpleColour}[+]${endColour} Cambiando la dirección MAC de ${yellowColour}$INTERFACE${endColour} a ${yellowColour}$NEW_MAC${endColour}"

# Aplicar cambios con macchanger
ip link set dev "$INTERFACE" down
macchanger --mac="$NEW_MAC" "$INTERFACE"
ip link set dev "$INTERFACE" up

echo -e "${purpleColour}[+]${endColour} Dirección MAC cambiada con éxito."
