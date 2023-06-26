#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo.....${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+c
trap ctrl_c INT

# Variable globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} uso:${endColour}"
  echo -e "\t${purpleColour}u) Actualizar documentos${endColour}"
  echo -e "\t${purpleColour}m) Buscar por nombre de maquina${endColour}"
  echo -e "\t${purpleColour}i) Buscar por direcciòn IP${endColour}"
  echo -e "\t${purpleColour}d) Buscar por la dificultad de una maquina${endColour}"
  echo -e "\t${purpleColour}o) Buscar por el sistema operativo${endColour}"
  echo -e "\t${purpleColour}s) Buscar por Skill${endColour}"
  echo -e "\t${purpleColour}y) Obtener link de la resoluciòn de la maquina en Youtube${endColour}"
  echo -e "\t${purpleColour}h) Mostrar este panel de ayuda${endColour}"
}

function updateFiles(){

  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos fueron descargados exitosamente${endColour}"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${blueColour} Comprobando si hay actualizaciones pendientes....${endColour}"
    curl -s $main_url > bundle_temp.js
    js-beautify bundle.js | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')

    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n${yellowColour}[+]${blueColour} No se han detectado actualizaciones${endColour}"
      rm bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${blueColour} se han encontrado actualizaciones${endColour}"
      sleep 1
      rm bundle.js && mv bundle_temp.js bundle.js
      echo -e "\n${yellowColour}[+]${blueColour} Los archivos se han actualizado${endColour}"
    fi
    tput cnorm
  fi
}

function searchMachine(){
  machineName="$1"
  verificationMachine="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//')"

if [ "$verificationMachine" ]; then

  echo -e "\n${yellowColour}[+]${grayColour} Listando las propiedades de la màquina $machineName$endColour${grayColour}:$endColour\n"
#  cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//'
  name="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'name:' | awk '{start=index($0,$2); print substr($0, start)}')"
  ip="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'ip:' | awk '{start=index($0,$2); print substr($0, start)}')"
  so="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'so:' | awk '{start=index($0,$2); print substr($0, start)}')"
  dificultad="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'dificultad:' | awk '{start=index($0,$2); print substr($0, start)}')"
  skills="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'skills:' | awk '{start=index($0,$2); print substr($0, start)}')"
  like="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'like:' | awk '{start=index($0,$2); print substr($0, start)}')"
  youtube="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'youtube:' | awk '{start=index($0,$2); print substr($0, start)}'\n)"
  activeDirectory="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'activeDirectory:' | awk '{start=index($0,$2); print substr($0, start)}'\n)"

  echo -e "$yellowColour[-]${redColour} Nombre: $greenColour$name${endColour}"
  echo -e "$yellowColour[-]${redColour} IP: $greenColour$ip${endColour}"
  echo -e "$yellowColour[-]${redColour} SO: $greenColour$so${endColour}"
  echo -e "$yellowColour[-]${redColour} Dificultad: $greenColour$dificultad${endColour}"
  echo -e "$yellowColour[-]${redColour} Skills: $greenColour$skills${endColour}"
  echo -e "$yellowColour[-]${redColour} Like: $greenColour$like${endColour}"
  echo -e "$yellowColour[-]${redColour} Link de youtube: $greenColour$youtube${endColour}"
  
  
  if [ "$activeDirectory" == "Active Directory" ]; then
    echo -e "$yellowColour[-]${redColour} Active Directory: $greenColour Si${endColour}\n"
  else
    echo -e "$yellowColour[-]${redColour} Active Directory: $greenColour No${endColour}\n"
  fi
else
  echo -e "$redColour[!]${redColour} No existe la maquina${endColour}"
fi
  }

function searchIP(){
  ipAddress="$1"

  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
  if [ "$machineName" ]; then

  echo -e "$yellowColour[+]${grayColour} La maquina correspondiente para la IP ${blueColour} $ipAddress ${grayColour}es ${purpleColour}$machineName${endColour}\n"

  searchMachine $machineName
  else
    echo -e "\n$redColour[!]${redColour} No existe la maquina${endColour}\n"
  fi
  }

function getYoutubeLink(){
  machineName="$1"

  youtube="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE 'id:|sku:|resuelta' | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep 'youtube' | awk '{start=index($0,$2); print substr($0, start)}'\n)"
  if [ "$youtube" ]; then
    echo -e "$yellowColour[+]${grayColour} El video de la resoluciòn para la maquina ${blueColour} $machineName ${grayColour}es ${purpleColour}$youtube${endColour}\n"
  else
    echo -e "\n$redColour[!]${redColour} No existe la maquina${endColour}\n"
  fi
}

function getMachineDifficulty(){
  difficulty="$1"
  listDiff="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$listDiff" ]; then
    echo -e "$yellowColour[+]${grayColour} Las maquinas con la dificultad ${blueColour} $difficulty ${grayColour} son \n "
    cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n$redColour[!]${redColour} No existe la categoria${endColour}\n"
  fi
}

function getOperativeSys(){
  operativeSys="$1"
  listOp="$(cat bundle.js | grep "so: \"$operativeSys\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$listOp" ]; then
    echo -e "$yellowColour[+]${grayColour} Las maquinas con el sistema operativo ${blueColour} $operativeSys ${grayColour} son \n "
    cat bundle.js | grep "so: \"$operativeSys\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n$redColour[!]${redColour} No existe ninguna maquina con ese sistema operativo${endColour}\n"
  fi
}

function getOsDifficultyMachine(){
  diff="$1"
  os="$2"
  echo "hola"

  check_result="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$diff\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$check_result" ]; then
    echo "POR AQUI"
    echo -e "$yellowColour[+]${grayColour} Las maquinas con el filtro ${grayColour} SO: ${blueColour} $os ${grayColour} Dificultad: ${blueColour} $diff ${grayColour} son \n "
    cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$diff\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n$redColour[!]${redColour} No existe ninguna maquina con ese filtro ${endColour}\n"
  fi
}

function getSkill(){
  skill="$1"
  echo $skill

  check_skill="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [ "$check_skill" ]; then 
    echo -e "$yellowColour[+]${grayColour} Las maquinas con las skills buscadas ${blueColour} $skill ${grayColour} son \n "
    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n$redColour[!]${redColour} No existe ninguna maquina con ese filtro ${endColour}\n"
  fi
}

# Indicadores
declare -i paremeter_counter=0

#chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:h" arg; do 
  case $arg in
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; let chivato_difficulty=1 let parameter_counter+=5;;
    o) operativeSys="$OPTARG"; let chivato_os=1 let parameter_counter+=6;;
    s) skill="$OPTARG"; let parameter_counter+=7;;
    h) ;;
  esac
done

if [[ $parameter_counter -eq 1 ]]; then
  searchMachine $machineName
elif [[ $parameter_counter -eq 2 ]]; then
  updateFiles
elif [[ $parameter_counter -eq 3 ]]; then
  searchIP $ipAddress
elif [[ $parameter_counter -eq 4 ]]; then
  getYoutubeLink $machineName
elif [[ $parameter_counter -eq 5 ]]; then
  getMachineDifficulty  $difficulty
elif [[ $parameter_counter -eq 6 ]]; then
  getOperativeSys $operativeSys
elif [[ $chivato_difficulty -eq 1 ]] && [[ $chivato_os -eq 1 ]]; then
  getOsDifficultyMachine $difficulty $operativeSys
elif [[ $parameter_counter -eq 7 ]]; then
  getSkill "$skill"
else
  helpPanel 
fi









