#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
NC='\e[0m'

echo -e "${YELLOW}

   _____          __       ____   ____    .__
  /  _  \  __ ___/  |_  ___\   \ /   /___ |  |  ${RED}--Version: 1.2 ${YELLOW}
 /  /_\  \|  |  \   __\/  _ \   Y   /  _ \|  |  ${RED} (@ualanl248) ${YELLOW}  
/    |    \  |  /|  | (  <_> )     (  <_> )  |__
\____|__  /____/ |__|  \____/ \___/ \____/|____/
        \/
${NC}"

read -rep $'\nRuta del volcado> ' RUTA

read -ra PLUGINS -p $'Plugins que quieres usar (separados por espacios)> '

echo -e "\n[*] Seleccionando los perfiles más óptimos para el volcado según Volatility...\n" 

array=($(vol.py -f $RUTA imageinfo 2>/dev/null | grep "Suggested Profile")) 

unset array[0]
unset array[1]
unset array[2]

echo -e "[${BLUE}INFO${NC}] Perfiles recomendados: ${array[@]}" 
read -rep $'Número del perfil (por orden de aparición)> ' seleccionPerfil

PROFILE=${array[(seleccionPerfil - 1) + 3]} #Se suma un offset de 3 porque al hacer los unsets la posición inicial del array queda en array[3] 
PROFILE="${PROFILE//\,/}"   

echo -e "\n[*] Todos los plugins se ejecutarán con: ${GREEN}$PROFILE${NC}. Todos los perfiles guardados en ~/outputs/$PROFILE.txt.\n"

mkdir -p ~/outputs

echo "${array[@]}" > ~/outputs/$PROFILE.txt

for plugin in "${PLUGINS[@]}"; do 
	vol.py -f $RUTA --profile=$PROFILE $plugin > ~/outputs/$plugin.txt 2>/dev/null
	echo -e "[${GREEN}LISTO${NC}] Resultado de $plugin guardado en ~/outputs/$plugin.txt."
done
