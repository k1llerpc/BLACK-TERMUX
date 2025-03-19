#!/bin/bash

# Farbdefinitionen
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Auto-Vervollständigung aktivieren
if [ -f /data/data/com.termux/files/usr/share/bash-completion/bash_completion ]; then
    source /data/data/com.termux/files/usr/share/bash-completion/bash_completion
fi

# Header-Funktion
show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}              ${GREEN}BLACK-TERMUX${CYAN}                      ${NC}"
    echo -e "${CYAN}      ${YELLOW}Eine bessere Termux-Bedienung${CYAN}              ${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Funktion, um eine Liste von Elementen anzuzeigen und eine Auswahl zu ermöglichen
select_from_list() {
    local options=("$@")
    local i=1
    
    for opt in "${options[@]}"; do
        echo -e "${GREEN}$i)${NC} $opt"
        ((i++))
    done
    
    echo -e "${RED}0)${NC} Zurück"
    
    while true; do
        read -p "Wähle eine Option (0-$((i-1))): " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt "$i" ]; then
            return "$choice"
        else
            echo -e "${RED}Ungültige Eingabe. Bitte erneut versuchen.${NC}"
        fi
    done
}

# Python-Dateien im Ordner auflisten und ausführen
python_files() {
    show_header
    echo -e "${BLUE}Python-Dateien in /sdcard/py/${NC}\n"
    
    # Prüfen, ob das Verzeichnis existiert
    if [ ! -d "/sdcard/py/" ]; then
        echo -e "${RED}Das Verzeichnis /sdcard/py/ existiert nicht.${NC}"
        read -p "Drücke ENTER zum Fortfahren..."
        return
    fi
    
    # Python-Dateien finden
    files=($(find /sdcard/py/ -maxdepth 1 -name "*.py" | sort))
    
    if [ ${#files[@]} -eq 0 ]; then
        echo -e "${YELLOW}Keine Python-Dateien gefunden.${NC}"
        read -p "Drücke ENTER zum Fortfahren..."
        return
    fi
    
    # Nur Dateinamen ohne Pfad für die Anzeige extrahieren
    display_files=()
    for file in "${files[@]}"; do
        display_files+=($(basename "$file"))
    done
    
    select_from_list "${display_files[@]}"
    choice=$?
    
    if [ $choice -eq 0 ]; then
        return
    fi
    
    # Python-Datei ausführen und Fehler abfangen
    chosen_file="${files[$((choice-1))]}"
    echo -e "\n${GREEN}Starte: ${YELLOW}$chosen_file${NC}\n"
    
    # Führe die Python-Datei aus und fange Fehler ab
    output=$(python "$chosen_file" 2>&1)
    exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}Fehler beim Ausführen der Datei:${NC}\n$output"
        
        # Überprüfen, ob der Fehler auf fehlende Module hinweist
        if echo "$output" | grep -q "ModuleNotFoundError"; then
            # Extrahiere den Modulnamen aus der Fehlermeldung
            missing_module=$(echo "$output" | grep -oP "(?<=No module named ')[^']+")
            echo -e "${YELLOW}Möchtest du das fehlende Modul '${missing_module}' installieren? (j/n): ${NC}"
            read -r install_choice
            
            if [[ "$install_choice" == "j" || "$install_choice" == "J" ]]; then
                echo -e "${GREEN}Installiere Modul: ${missing_module}${NC}"
                pip install "$missing_module"
                echo -e "${GREEN}Modul '${missing_module}' wurde installiert.${NC}"
                
                # Versuche die Datei erneut auszuführen
                output=$(python "$chosen_file" 2>&1)
                exit_code=$?
                
                if [ $exit_code -eq 0 ]; then
                    echo -e "${GREEN}Die Datei wurde erfolgreich ausgeführt.${NC}"
                else
                    echo -e "${RED}Fehler beim erneuten Ausführen der Datei:${NC}\n$output"
                fi
            fi
        fi
    } else {
        echo -e "${GREEN}Die Datei wurde erfolgreich ausgeführt.${NC}"
    }
    
    read -p "Drücke ENTER zum Fortfahren..."
}

# Module installieren
install_module() {
    show_header
    echo -e "${BLUE}Python-Module installieren${NC}\n"
    
    read -p "Modulname eingeben (oder leer für Zurück): " module_name
    
    if [ -z "$module_name" ]; then
        return
    fi
    
    echo -e "\n${GREEN}Installiere Modul: ${YELLOW}$module_name${NC}\n"
    pip install "$module_name"
    
    read -p "Drücke ENTER zum Fortfahren..."
}

# Module aktualisieren
update_modules() {
    show_header
    echo -e "${BLUE}Python-Module aktualisieren${NC}\n"
    
    echo -e "${GREEN}Installierte Module:${NC}"
    pip list
    echo ""
    
    read -p "Möchtest du alle Module aktualisieren? (j/n): " confirm
    
    if [[ "$confirm" == "j" || "$confirm" == "J" ]]; then
        echo -e "\n${GREEN}Aktualisiere alle Module...${NC}\n"
        pip list --outdated | cut -d ' ' -f 1 | tail -n +3 | xargs -r pip install --upgrade
        echo -e "\n${GREEN}Aktualisierung abgeschlossen.${NC}"
    fi
    
    read -p "Drücke ENTER zum Fortfahren..."
}

# Ordner in /sdcard/ auflisten
browse_sdcard() {
    show_header
    echo -e "${BLUE}Ordner in /sdcard/ durchsuchen${NC}\n"
    
    # Alle Ordner in /sdcard/ finden
    directories=($(find /sdcard/ -maxdepth 1 -type d | sort))
    
    # Nur Ordnernamen ohne Pfad für die Anzeige extrahieren
    display_dirs=()
    for dir in "${directories[@]}"; do
        if [ "$dir" != "/sdcard/" ]; then
            display_dirs+=($(basename "$dir"))
        fi
    done
    
    select_from_list "${display_dirs[@]}"
    choice=$?
    
    if [ $choice -eq 0 ]; then
        return
    fi
    
    chosen_dir="/sdcard/${display_dirs[$((choice-1))]}"
    
    # Python-Dateien im gewählten Ordner anzeigen
    show_header
    echo -e "${BLUE}Python-Dateien in ${YELLOW}$chosen_dir${NC}\n"
    
    # Python-Dateien finden
    py_files=($(find "$chosen_dir" -maxdepth 1 -name "*.py" | sort))
    
    if [ ${#py_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}Keine Python-Dateien gefunden.${NC}"
        read -p "Drücke ENTER zum Fortfahren..."
        return
    fi
    
    # Nur Dateinamen ohne Pfad für die Anzeige extrahieren
    display_files=()
    for file in "${py_files[@]}"; do
        display_files+=($(basename "$file"))
    done
    
    select_from_list "${display_files[@]}"
    file_choice=$?
    
    if [ $file_choice -eq 0 ]; then
        browse_sdcard
        return
    fi
    
    # Python-Datei ausführen
    chosen_file="${py_files[$((file_choice-1))]}"
    echo -e "\n${GREEN}Starte: ${YELLOW}$chosen_file${NC}\n"
    python "$chosen_file"
    
    read -p "Drücke ENTER zum Fortfahren..."
}

# Normales Termux-Terminal starten
start_terminal() {
    show_header
    echo -e "${BLUE}Termux Terminal${NC}\n"
    echo -e "${YELLOW}Gib 'exit' ein, um zum Hauptmenü zurückzukehren.${NC}\n"
    
    # Wechsel zur Bash-Shell
    $SHELL
}

# Hauptmenü
main_menu() {
    while true; do
        show_header
        echo -e "${BLUE}Hauptmenü${NC}\n"
        
        options=(
            "📂 1) Python-Dateien (aus /py/)"
            "📦 2) Module Installieren"
            "🔄 3) Module Updaten"
            "📁 4) Ordner in /sdcard/ "
            "🖥️ 5) Termux Terminal"
            "🚪 6) Beenden"
        )
        
        for opt in "${options[@]}"; do
            echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
            echo -e "${CYAN}  ${GREEN}${opt}${CYAN}  ${NC}"
            echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
        done
        
        echo -e "${RED}0)${NC} Zurück"
        
        while true; do
            read -p "Wähle eine Option (0-$(( ${#options[@]} ))): " choice
            
            if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt "$(( ${#options[@]} + 1 ))" ]; then
                case $choice in
                    0) return ;;
                    *) 
                        case $choice in
                            1) python_files ;;
                            2) install_module ;;
                            3) update_modules ;;
                            4) browse_sdcard ;;
                            5) start_terminal ;;
                            6) echo -e "\n${GREEN}Auf Wiedersehen!${NC}"; exit 0 ;;
                        esac
                    fi
                else
                    echo -e "${RED}Ungültige Eingabe. Bitte erneut versuchen.${NC}"
                fi
            done
        done
}
main_menu
