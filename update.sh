#!/data/data/com.termux/files/usr/bin/bash

# Variables
BOT_DIR="TURBITO-BOT-V5"
BOT_REPO="https://github.com/JereCrack05/$BOT_DIR"
DB_FILE="database.json"
GREEN='\033[32m'
BOLD='\033[1m'
RESET='\033[0m'

# Función para clonar y configurar el repositorio
setup_repo() {
    echo -e "${BOLD}${GREEN}Clonando repositorio $BOT_REPO en $HOME...${RESET}"
    cd && rm -rf "$HOME/$BOT_DIR" && git clone "$BOT_REPO" && cd "$HOME/$BOT_DIR"
    echo -e "${BOLD}${GREEN}Instalando dependencias...${RESET}"
    npm install
}

# Verificar si estamos en el directorio del bot
if [[ $(basename "$PWD") == "$BOT_DIR" ]]; then
    if [ -e "$DB_FILE" ]; then
        echo -e "${BOLD}${GREEN}Moviendo $DB_FILE a $HOME y clonando repositorio $BOT_REPO en $HOME...${RESET}"
        mv "$HOME/$BOT_DIR/$DB_FILE" "$HOME" && setup_repo
        if [ -e "$HOME/$DB_FILE" ]; then
            echo -e "${BOLD}${GREEN}Rescatando archivo $DB_FILE y moviendo a $BOT_DIR.${RESET}"
            mv "$HOME/$DB_FILE" "$HOME/$BOT_DIR/" && cd "$BOT_DIR" && npm start
        else
            echo -e "${BOLD}${GREEN}$DB_FILE no existe en $HOME${RESET}"
            cd "$BOT_DIR" && npm start
        fi
    else
        echo -e "${BOLD}${GREEN}$DB_FILE no se encontró en $BOT_DIR, clonando repositorio $BOT_REPO en $HOME...${RESET}"
        setup_repo
        if [ -e "$HOME/$DB_FILE" ]; then
            echo -e "${BOLD}${GREEN}Rescatando archivo $DB_FILE y moviendo a $BOT_DIR.${RESET}"
            mv "$HOME/$DB_FILE" "$HOME/$BOT_DIR/" && cd "$BOT_DIR" && npm start
        else
            echo -e "${BOLD}${GREEN}$DB_FILE no existe en $HOME${RESET}"
            cd "$BOT_DIR" && npm start
        fi
    fi
else
    echo -e "${BOLD}${GREEN}Ubicación actual: $HOME${RESET}"
    cd "$HOME"
    if [ -e "$HOME/$BOT_DIR" ]; then
        echo -e "${BOLD}${GREEN}Dirigiéndome a $BOT_DIR.${RESET}"
        cd "$HOME/$BOT_DIR"
        if [ -e "$HOME/$BOT_DIR/$DB_FILE" ]; then
            echo -e "${BOLD}${GREEN}Moviendo $DB_FILE a $HOME y clonando repositorio $BOT_REPO en $HOME...${RESET}"
            mv "$HOME/$BOT_DIR/$DB_FILE" "$HOME" && setup_repo
            if [ -e "$HOME/$DB_FILE" ]; then
                echo -e "${BOLD}${GREEN}Rescatando archivo $DB_FILE y moviendo a $BOT_DIR.${RESET}"
                mv "$HOME/$DB_FILE" "$HOME/$BOT_DIR/" && cd "$BOT_DIR" && npm start
            else
                echo -e "${BOLD}${GREEN}Dirigiéndome a $BOT_DIR...${RESET}"
                cd "$BOT_DIR" && npm start
            fi
        else
            echo -e "${BOLD}${GREEN}$DB_FILE no existe, clonando repositorio $BOT_REPO en $HOME...${RESET}"
            setup_repo
            npm start
        fi
    else
        echo -e "${BOLD}${GREEN}$BOT_DIR no existe, clonando repositorio $BOT_REPO en $HOME...${RESET}"
        setup_repo
        npm start
    fi
fi

