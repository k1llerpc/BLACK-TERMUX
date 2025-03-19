#!/bin/bash

# Farbiger Header
echo -e "\e[38;5;46m========================================\e[0m"
echo -e "\e[38;5;46m        BLACK-TERMUX - Hauptmenü        \e[0m"
echo -e "\e[38;5;46m========================================\e[0m"

# Hauptmenü
PS3="Bitte wählen Sie eine Option: "
options=(
    "Python Installieren/Updaten"
    "Module Installieren"
    "Module Updaten"
    "PKG Installieren"
    "PKG Updaten"
    "Pys Laden"
    "Ordner"
    "Termux Terminal"
    "Beenden"
)
select opt in "${options[@]}"; do
    case $opt in
        "Python Installieren/Updaten")
            python_install_update
            ;;
        "Module Installieren")
            module_install
            ;;
        "Module Updaten")
            module_update
            ;;
        "PKG Installieren")
            pkg_install
            ;;
        "PKG Updaten")
            pkg_update
            ;;
        "Pys Laden")
            pys_laden
            ;;
        "Ordner")
            ordner_auswahl
            ;;
        "Termux Terminal")
            termux_terminal
            ;;
        "Beenden")
            break
            ;;
        *) echo "Ungültige Option: $REPLY";;
    esac
done

# Funktionen für die einzelnen Optionen
python_install_update() {
    echo "Python wird installiert/geupdatet..."
    pkg install -y python
    echo "Fertig!"
    zurueck_zum_hauptmenu
}

module_install() {
    echo "Bitte geben Sie den Namen des Moduls ein, das Sie installieren möchten:"
    read modulname
    echo "Modul $modulname wird installiert..."
    pip install "$modulname"
    echo "Fertig!"
    zurueck_zum_hauptmenu
}

module_update() {
    echo "Alle Module werden geupdatet..."
    pip freeze | xargs pip install -U
    echo "Fertig!"
    zurueck_zum_hauptmenu
}

pkg_install() {
    echo "Bitte geben Sie den Namen des Pakets ein, das Sie installieren möchten:"
    read paketname
    echo "Paket $paketname wird installiert..."
    pkg install "$paketname"
    echo "Fertig!"
    zurueck_zum_hauptmenu
}

pkg_update() {
    echo "Alle Pakete werden geupdatet..."
    pkg upgrade
    echo "Fertig!"
    zurueck_zum_hauptmenu
}

pys_laden() {
    echo "Python-Dateien im Ordner /sdcard/py/ werden geladen..."
    local i=1
    for file in /sdcard/py/*.py; do
        echo "$i) $(basename "$file")"
        ((i++))
    done
    echo "Bitte wählen Sie eine Datei zum Ausführen (oder 0 zum Abbrechen):"
    read auswahl
    if [ "$auswahl" -eq 0 ]; then
        zurueck_zum_hauptmenu
    else
        local datei=$(ls /sdcard/py/*.py | sed -n "${auswahl}p")
        if [ -f "$datei" ]; then
            python "$datei"
        else
            echo "Ungültige Auswahl."
        fi
    fi
    zurueck_zum_hauptmenu
}

ordner_auswahl() {
    echo "Ordner in /sdcard/ werden aufgelistet..."
    local i=1
    for dir in /sdcard/*; do
        if [ -d "$dir" ]; then
            echo "$i) $(basename "$dir")"
            ((i++))
        fi
    done
    echo "Bitte wählen Sie einen Ordner (oder 0 zum Abbrechen):"
    read auswahl
    if [ "$auswahl" -eq 0 ]; then
        zurueck_zum_hauptmenu
    else
        local ordner=$(ls -d /sdcard/*/ | sed -n "${auswahl}p")
        if [ -d "$ordner" ]; then
            echo "Python-Dateien im Ordner $(basename "$ordner") werden geladen..."
            local j=1
            for file in "$ordner"*.py; do
                echo "$j) $(basename "$file")"
                ((j++))
            done
            echo "Bitte wählen Sie eine Datei zum Ausführen (oder 0 zum Abbrechen):"
            read dateiauswahl
            if [ "$dateiauswahl" -eq 0 ]; then
                zurueck_zum_hauptmenu
            else
                local datei=$(ls "$ordner"*.py | sed -n "${dateiauswahl}p")
                if [ -f "$datei" ]; then
                    python "$datei"
                else
                    echo "Ungültige Auswahl."
                fi
            fi
        else
            echo "Ungültige Auswahl."
        fi
    fi
    zurueck_zum_hauptmenu
}

termux_terminal() {
    echo "Wechsel zum Termux Terminal..."
    exec bash
}

zurueck_zum_hauptmenu() {
    echo "Drücken Sie eine beliebige Taste, um zum Hauptmenü zurückzukehren..."
    read -n 1
    clear
    . "$0"
}
