# Termux Custom Shell

Eine benutzerfreundliche Shell für Termux mit modernem Layout und verbesserten Funktionen. Diese Shell bietet eine einfache Menüführung für häufig verwendete Python-Aufgaben und verbessert die Benutzererfahrung in Termux erheblich.

![Termux Custom Shell](https://via.placeholder.com/800x400?text=Termux+Custom+Shell)

## Funktionen

- 🎨 **Modernes Layout** mit farbigem Header und ansprechender Gestaltung
- 🔄 **Auto-Vervollständigung** für Befehle und Eingaben
- 🐍 **Python-Dateiverwaltung** mit einfacher Ausführung von Python-Skripten
- 📦 **Modulverwaltung** zum einfachen Installieren und Aktualisieren von Python-Paketen
- 🔍 **Datei-Browser** für die Speicherkarte mit Fokus auf Python-Dateien
- 🔙 **Zurück-Funktion** in allen Menüs, um zum Hauptmenü zurückzukehren
- 🔄 **Nahtlose Integration** mit dem regulären Termux-Terminal

## Installation

### Methode 1: Direkte Installation (empfohlen)

1. Öffne Termux auf deinem Android-Gerät
2. Führe die folgenden Befehle aus:

```bash
# Installiere Git, falls noch nicht vorhanden
pkg install git

# Klone das Repository
git clone https://github.com/k1llerpc/BLACK-TERMUX

# Wechsle ins Projektverzeichnis
cd BLACK-TERMUX

# Führe das Installations-Skript aus
bash install.sh
```

### Methode 2: Manuelle Installation

1. Lade die Dateien `termux_custom_shell.sh` und `install.sh` herunter
2. Kopiere sie nach Termux (z.B. per USB oder Cloud-Dienst)
3. Öffne Termux und führe folgende Befehle aus:

```bash
# Mache das Installationsskript ausführbar
chmod +x install.sh

# Führe das Installations-Skript aus
./install.sh
```

## Verwendung

Nach der Installation kannst du die Shell starten mit:

```bash
~/termux_custom_shell.sh
```

Oder aktiviere den automatischen Start während der Installation, damit die Shell bei jedem Start von Termux automatisch geladen wird.

### Hauptmenü-Optionen:

1. **Python-Dateien**: Listet alle Python-Dateien im Ordner `/sdcard/py/` auf und ermöglicht deren Ausführung.
2. **Module Installieren**: Vereinfachte Installation von Python-Paketen.
3. **Module Updaten**: Aktualisierung aller installierten Python-Module.
4. **Ordner durchsuchen**: Durchsuche die Speicherkarte nach Python-Dateien.
5. **Termux Terminal**: Öffne das normale Termux-Terminal (zurück zum Menü mit `exit`).

## Anpassung

Du kannst die Shell an deine Bedürfnisse anpassen, indem du die Datei `~/termux_custom_shell.sh` bearbeitest:

- Farben ändern: Bearbeite die Farbdefinitionen am Anfang der Datei
- Menüpunkte hinzufügen: Erweitere die `options`-Array in der `main_menu`-Funktion
- Funktionen hinzufügen: Erstelle neue Funktionen und verknüpfe sie im Hauptmenü

## Anforderungen

- Termux-App auf Android
- Python für Termux (`pkg install python`)
- Bash-Completion (`pkg install bash-completion`)
- Speicherzugriff (`termux-setup-storage`)

## Beitragen

Beiträge sind willkommen! Wenn du eine Verbesserung oder Erweiterung hast, erstelle einen Pull Request oder öffne ein Issue.

## Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe die [LICENSE](LICENSE)-Datei für Details. 