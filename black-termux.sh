#!/data/data/com.termux/files/usr/bin/bash

# Farben
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Header Funktion
show_header() {
    clear
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════╗"
    echo "║             BLACK-TERMUX                 ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Python Installation/Update
install_python() {
    while true; do
        show_header
        echo -e "${CYAN}Python Installation/Update${NC}\n"
        echo "1. Python installieren/updaten"
        echo "0. Zurück zum Hauptmenü"
        
        read -p "Wähle eine Option: " choice
        case $choice in
            1)
                pkg update -y && pkg upgrade -y
                pkg install python -y
                echo -e "\n${GREEN}Python wurde installiert/geupdated${NC}"
                read -p "Drücke Enter zum fortfahren..."
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Python Module Installation
install_module() {
    while true; do
        show_header
        echo -e "${CYAN}Python Module Installation${NC}\n"
        echo "1. Modul installieren"
        echo "0. Zurück zum Hauptmenü"
        
        read -p "Wähle eine Option: " choice
        case $choice in
            1)
                read -p "Gib den Namen des Moduls ein: " module
                pip install $module
                echo -e "\n${GREEN}Modul wurde installiert${NC}"
                read -p "Drücke Enter zum fortfahren..."
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Module updaten
update_modules() {
    while true; do
        show_header
        echo -e "${CYAN}Python Module Update${NC}\n"
        echo "1. Alle Module updaten"
        echo "0. Zurück zum Hauptmenü"
        
        read -p "Wähle eine Option: " choice
        case $choice in
            1)
                pip list --outdated | cut -d ' ' -f1 | xargs -n1 pip install -U
                echo -e "\n${GREEN}Alle Module wurden geupdated${NC}"
                read -p "Drücke Enter zum fortfahren..."
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                sleep 1
                ;;
        esac
    done
}

# PKG Installation
install_pkg() {
    while true; do
        show_header
        echo -e "${CYAN}Termux Paket Installation${NC}\n"
        echo "1. Paket installieren"
        echo "0. Zurück zum Hauptmenü"
        
        read -p "Wähle eine Option: " choice
        case $choice in
            1)
                read -p "Gib den Namen des Pakets ein: " package
                pkg install $package -y
                echo -e "\n${GREEN}Paket wurde installiert${NC}"
                read -p "Drücke Enter zum fortfahren..."
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                sleep 1
                ;;
        esac
    done
}

# PKG Update
update_pkg() {
    while true; do
        show_header
        echo -e "${CYAN}Termux Paket Update${NC}\n"
        echo "1. Alle Pakete updaten"
        echo "0. Zurück zum Hauptmenü"
        
        read -p "Wähle eine Option: " choice
        case $choice in
            1)
                pkg update -y && pkg upgrade -y
                echo -e "\n${GREEN}Alle Pakete wurden geupdated${NC}"
                read -p "Drücke Enter zum fortfahren..."
                ;;
            0)
                return
                ;;
            *)
                echo -e "${RED}Ungültige Option${NC}"
                sleep 1
                ;;
        esac
    done
}

# Python Dateien laden
load_pys() {
    while true; do
        show_header
        echo -e "${CYAN}Python Dateien aus /sdcard/py/${NC}\n"
        
        if [ ! -d "/sdcard/py" ]; then
            mkdir -p /sdcard/py
        fi
        
        files=($(ls /sdcard/py/*.py 2>/dev/null))
        if [ ${#files[@]} -eq 0 ]; then
            echo "Keine Python Dateien gefunden"
            echo "0. Zurück zum Hauptmenü"
        else
            for i in "${!files[@]}"; do
                echo "$((i+1)). $(basename ${files[$i]})"
            done
            echo "0. Zurück zum Hauptmenü"
        fi
        
        read -p "Wähle eine Datei: " choice
        if [ "$choice" = "0" ]; then
            return
        elif [ "$choice" -gt 0 ] && [ "$choice" -le ${#files[@]} ]; then
            python "${files[$((choice-1))]}"
            read -p "Drücke Enter zum fortfahren..."
        else
            echo -e "${RED}Ungültige Option${NC}"
            sleep 1
        fi
    done
}

# Ordner Navigation
browse_folders() {
    while true; do
        show_header
        echo -e "${CYAN}Ordner Navigation${NC}\n"
        
        folders=($(ls -d /sdcard/*/ 2>/dev/null))
        for i in "${!folders[@]}"; do
            echo "$((i+1)). $(basename ${folders[$i]})"
        done
        echo "0. Zurück zum Hauptmenü"
        
        read -p "Wähle einen Ordner: " choice
        if [ "$choice" = "0" ]; then
            return
        elif [ "$choice" -gt 0 ] && [ "$choice" -le ${#folders[@]} ]; then
            selected_folder="${folders[$((choice-1))]}"
            while true; do
                show_header
                echo -e "${CYAN}Python Dateien in $(basename $selected_folder)${NC}\n"
                
                files=($(ls $selected_folder/*.py 2>/dev/null))
                if [ ${#files[@]} -eq 0 ]; then
                    echo "Keine Python Dateien gefunden"
                    echo "0. Zurück"
                else
                    for i in "${!files[@]}"; do
                        echo "$((i+1)). $(basename ${files[$i]})"
                    done
                    echo "0. Zurück"
                fi
                
                read -p "Wähle eine Datei: " file_choice
                if [ "$file_choice" = "0" ]; then
                    break
                elif [ "$file_choice" -gt 0 ] && [ "$file_choice" -le ${#files[@]} ]; then
                    python "${files[$((file_choice-1))]}"
                    read -p "Drücke Enter zum fortfahren..."
                else
                    echo -e "${RED}Ungültige Option${NC}"
                    sleep 1
                fi
            done
        else
            echo -e "${RED}Ungültige Option${NC}"
            sleep 1
        fi
    done
}

# Hauptmenü
while true; do
    show_header
    echo -e "${BLUE}Hauptmenü${NC}\n"
    echo "1. Python Installieren/Updaten"
    echo "2. Module Installieren"
    echo "3. Module Updaten"
    echo "4. PKG Installieren"
    echo "5. PKG Updaten"
    echo "6. Pys Laden"
    echo "7. Ordner"
    echo "8. Termux Terminal"
    echo "0. Beenden"
    
    read -p "Wähle eine Option: " choice
    case $choice in
        1)
            install_python
            ;;
        2)
            install_module
            ;;
        3)
            update_modules
            ;;
        4)
            install_pkg
            ;;
        5)
            update_pkg
            ;;
        6)
            load_pys
            ;;
        7)
            browse_folders
            ;;
        8)
            exit
            ;;
        0)
            clear
            exit
            ;;
        *)
            echo -e "${RED}Ungültige Option${NC}"
            sleep 1
            ;;
    esac
done
