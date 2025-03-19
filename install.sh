#!/data/data/com.termux/files/usr/bin/bash

# Farben
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}BLACK-TERMUX Installation${NC}\n"

# Grundlegende Pakete installieren
echo -e "${GREEN}Installiere benötigte Pakete...${NC}"
pkg update -y
pkg upgrade -y
pkg install python -y

# Shell ausführbar machen
echo -e "\n${GREEN}Mache Shell ausführbar...${NC}"
chmod +x black-termux.sh

# Backup von existierender bashrc
if [ -f ~/.bashrc ]; then
    cp ~/.bashrc ~/.bashrc.backup
    echo -e "${GREEN}Backup von .bashrc erstellt als .bashrc.backup${NC}"
fi

# Füge Shell zum Autostart hinzu
echo -e "\n${GREEN}Füge Shell zum Autostart hinzu...${NC}"
echo "cd $(pwd)" > ~/.bashrc
echo "./black-termux.sh" >> ~/.bashrc

echo -e "\n${GREEN}Installation abgeschlossen!${NC}"
echo -e "${GREEN}Starte Termux neu um die Shell zu laden.${NC}"
