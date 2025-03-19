#!/bin/bash

# Skript ausführbar machen
chmod +x "$PWD/black-termux.sh"
chmod +x "$PWD/install.sh"

# Zeile zum automatischen Laden der Shell in die Datei .bashrc einfügen
if [ -f "$HOME/.bashrc" ]; then
  echo "bash $HOME/black-termux.sh" >> $HOME/.bashrc
fi

echo "Installation abgeschlossen!"
