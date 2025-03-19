#!/data/data/com.termux/files/usr/bin/bash

# Farben für bessere Lesbarkeit
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            ${GREEN}Termux Custom Shell Setup${BLUE}              ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Prüfen, ob wir in Termux sind
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${RED}Fehler: Dieses Skript muss in Termux auf Android ausgeführt werden!${NC}"
    exit 1
fi

echo -e "${GREEN}Installation wird gestartet...${NC}"

# Aktualisiere Paketliste
echo -e "\n${YELLOW}1. Aktualisiere Paketliste...${NC}"
pkg update -y

# Installiere notwendige Pakete
echo -e "\n${YELLOW}2. Installiere benötigte Pakete...${NC}"
pkg install -y python bash-completion findutils

# Richte Speicherzugriff ein
echo -e "\n${YELLOW}3. Richte Speicherzugriff ein...${NC}"
termux-setup-storage

# Warte auf die Bestätigung des Speicherzugriffs
echo -e "\n${GREEN}Bitte erteile Termux Zugriff auf deinen Speicher in der Android-Benachrichtigung${NC}"
echo -e "${YELLOW}Drücke ENTER, wenn du den Zugriff bestätigt hast...${NC}"
read

# Erstelle Python-Verzeichnis, falls es nicht existiert
echo -e "\n${YELLOW}4. Erstelle Python-Verzeichnis...${NC}"
mkdir -p /sdcard/py

# Kopiere die Shell in das Heimverzeichnis
echo -e "\n${YELLOW}5. Installiere die Custom Shell...${NC}"
cp termux_custom_shell.sh $HOME/

# Mache das Shell-Skript ausführbar
chmod +x $HOME/termux_custom_shell.sh

# Konfiguriere automatischen Start (optional)
echo -e "\n${YELLOW}6. Konfiguriere automatischen Start...${NC}"
read -p "Möchtest du die Custom Shell beim Start von Termux automatisch laden? (j/n): " AUTO_START

if [[ "$AUTO_START" == "j" || "$AUTO_START" == "J" ]]; then
    # Füge Zeile zur bashrc hinzu, falls nicht bereits vorhanden
    if ! grep -q "termux_custom_shell.sh" $HOME/.bashrc; then
        echo -e "\n# Starte Custom Shell" >> $HOME/.bashrc
        echo -e "$HOME/termux_custom_shell.sh" >> $HOME/.bashrc
        echo -e "${GREEN}Automatischer Start wurde konfiguriert.${NC}"
    else
        echo -e "${YELLOW}Automatischer Start war bereits konfiguriert.${NC}"
    fi
fi

# Erstelle ein einfaches Demo-Python-Skript
echo -e "\n${YELLOW}7. Erstelle Demo-Python-Datei...${NC}"
cat > /sdcard/py/hello.py << 'EOL'
#!/usr/bin/env python
# -*- coding: utf-8 -*-

print("="*50)
print("Willkommen zur Termux Custom Shell!")
print("Dies ist eine Demo-Python-Datei.")
print("="*50)

name = input("\nWie heißt du? ")
print(f"\nHallo {name}, schön dich kennenzulernen!")
print("\nDu kannst diese Datei als Vorlage für deine eigenen Skripte verwenden.")
input("\nDrücke ENTER zum Beenden...")
EOL

echo -e "\n${GREEN}Installation abgeschlossen!${NC}"
echo -e "${YELLOW}Du kannst die Custom Shell starten mit:${NC}"
echo -e "${BLUE}$HOME/termux_custom_shell.sh${NC}"

if [[ "$AUTO_START" == "j" || "$AUTO_START" == "J" ]]; then
    echo -e "${YELLOW}Die Shell wird beim nächsten Start von Termux automatisch geladen.${NC}"
fi

echo -e "\n${GREEN}Viel Spaß mit deiner neuen Termux Custom Shell!${NC}" 