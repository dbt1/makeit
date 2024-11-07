# Generisches Makefile zum Installieren von Lua- und Shell-Skript-Plugins und zugehöriger Dateien für Neutrino

## Inhaltsverzeichnis

- [Generisches Makefile zum Installieren von Lua- und Shell-Skript-Plugins und zugehöriger Dateien für Neutrino](#generisches-makefile-zum-installieren-von-lua--und-shell-skript-plugins-und-zugehöriger-dateien-für-neutrino)
  - [Inhaltsverzeichnis](#inhaltsverzeichnis)
  - [Überblick](#überblick)
  - [Verwendung](#verwendung)
    - [Grundlegende Befehle](#grundlegende-befehle)
      - [Hilfe](#hilfe)
      - [Installation](#installation)
      - [Deinstallation](#deinstallation)
      - [Dateien überprüfen](#dateien-überprüfen)
    - [Optionen](#optionen)
    - [Dateikategorien und Installationsverhalten](#dateikategorien-und-installationsverhalten)
    - [Makefile-Ziele](#makefile-ziele)
  - [Beispielverwendung](#beispielverwendung)
  - [Lokale Konfiguration](#lokale-konfiguration)
    - [Beispiel Makefile.local](#beispiel-makefilelocal)
  - [Integration in Yocto/OpenEmbedded Buildsystem](#integration-in-yoctoopenembedded-buildsystem)
    - [Beispielrezept für Yocto/OE](#beispielrezept-für-yoctooe)
  - [Integration in ein selbsterstelltes Buildsystem oder Crosstool-NG](#integration-in-ein-selbsterstelltes-buildsystem-oder-crosstool-ng)
    - [Beispiel-Skript für ein selbsterstelltes Buildsystem](#beispiel-skript-für-ein-selbsterstelltes-buildsystem)
  - [Arbeitsweise des Makefiles](#arbeitsweise-des-makefiles)
  - [Hinweise](#hinweise)
  - [Fehlerbehebung](#fehlerbehebung)
  - [Lizenz](#lizenz)

## Überblick

Dieses `Makefile` wurde entwickelt, um die Installation, Deinstallation und Verwaltung von Lua- u. Shell-Skripten und zusätzlichen Dateien für die Neutrino-Umgebung nativ oder innerhalb eines Buildsystems zu ermöglichen. Es bietet verschiedene Anpassungsmöglichkeiten, die es flexibel und in unterschiedlichen Projekten wiederverwendbar machen.

## Verwendung

### Grundlegende Befehle

#### Hilfe

Um Nutzungsinformationen anzuzeigen, verwende:

```bash
make help
```

#### Installation

Um dein Skript und die zugehörigen Dateien zu installieren, verwende:

```bash
make install SCRIPT_NAME=<name> [options]
```

#### Deinstallation

Um die installierten Dateien zu deinstallieren, verwende:

```bash
make uninstall SCRIPT_NAME=<name> [options]
```

>**Hinweis**: Das Ziel `uninstall` ist obligatorisch vorhanden und eignet sich gut für lokale Tests, um sicherzustellen, dass installierte Dateien einfach entfernt werden können.

#### Dateien überprüfen

Um sicherzustellen, dass alle erforderlichen Dateien vorhanden sind, verwende:

```bash
make check SCRIPT_NAME=<name>
```

### Optionen

Optionen können als Umgebungsvariablen oder in `Makefile.local` festgelegt werden, um das Verhalten des `Makefile`s zu steuern. Die Optionen können direkt beim Aufruf des `Makefile`s übergeben werden oder als Umgebungsvariablen gesetzt werden, die für den gesamten Shell-Kontext gelten.

Beispielsweise kann `SCRIPT_NAME` entweder beim Aufruf des Befehls oder vorher gesetzt werden:

```bash
export SCRIPT_NAME=my-script
make install
```
oder in einer Befehlszeile:

```bash
make install SCRIPT_NAME=my-script
```

Hier sind die unterstützten Optionen:

- **`SCRIPT_NAME`** (erforderlich): Basisname des zu installierenden Ursprungsskripts. Beispiel:

  ```
  make install SCRIPT_NAME=my-script
  ```

- **`PROGRAM_PREFIX`** (optional): Fügt allen installierten Dateien ein Präfix hinzu.

- **`PROGRAM_SUFFIX`** (optional): Fügt allen installierten Dateien ein Suffix hinzu.

- **`TARGET_PROGRAM_NAME`** (optional): Gibt den vollständigen Namen für das installierte Programm an. Dies kann besonders nützlich sein, wenn eine spezifische Benennung für die installierten Dateien erforderlich ist.

- **`INSTALLDIR`** (optional): Verzeichnis, in das die Dateien installiert werden sollen. Standard ist `/usr/share/tuxbox/neutrino/plugins`.

- **`SOURCE_DIR`** (optional): Verzeichnis, in dem sich die Quelldateien befinden. Standard ist das Verzeichnis, welches das `Makefile` enthält.

- **`EXTRAFILES`** (optional): Zusätzliche zu installierende Dateien. Diese können einen vollständigen Pfad haben, was ermöglicht, dass sie auch aus anderen Speicherorten stammen.

### Dateikategorien und Installationsverhalten

- **Lua-Skripte (`*.lua`)**: Mit Ausführberechtigungen (`755`) installiert.
- **Shell-Skripte (`*.sh`)**: Mit Ausführberechtigungen (`755`) installiert.
- **Konfigurationsdateien (`*.cfg`)**: Mit Leseberechtigungen (`644`) installiert.
- **Datenbankdateien (`*.db`)**: Mit Leseberechtigungen (`644`) installiert.
- **Bilder (`*.png`)**: Mit Leseberechtigungen (`644`) installiert.
- **Shell-Skripte (`*.sh`)**: Mit Ausführberechtigungen (`755`) installiert.
- **Andere Dateien**: Mit Leseberechtigungen (`644`) installiert.

### Makefile-Ziele

- **`all`** (Standard): Führt das `install`-Ziel aus.
- **`help`**: Zeigt Hilfeinformationen an, die alle Optionen und Nutzungsbeispiele auflisten.
- **`check`**: Überprüft das Vorhandensein der erforderlichen Dateien vor der Installation.
- **`install`**: Installiert das Skript und die zugehörigen Dateien in das angegebene Verzeichnis.
- **`uninstall`**: Deinstalliert alle Dateien, die mit dem angegebenen `SCRIPT_NAME` verbunden sind. 
- **`clean`**: Platzhalter für sämtliche Aufräumarbeiten (gibt derzeit "Nothing to clean." aus).

## Beispielverwendung

1. **Einfache Installation**

   ```bash
   make install SCRIPT_NAME=my-script
   ```

2. **Installation mit Präfix und Suffix**

   ```bash
   make install SCRIPT_NAME=my-script PROGRAM_PREFIX=test- PROGRAM_SUFFIX=-v1
   ```

3. **Deinstallation**

   ```bash
   make uninstall SCRIPT_NAME=my-script
   ```

4. **Überprüfen der Dateien vor der Installation**

   ```bash
   make check SCRIPT_NAME=my-script
   ```

5. **Hilfe**

   ```bash
   make help
   ```

## Lokale Konfiguration

Du kannst eine `Makefile.local`-Datei im selben Verzeichnis wie dieses `Makefile` erstellen, um Standardwerte für die verwendeten Variablen festzulegen. Dies ist besonders nützlich für häufig verwendete Skripte oder benutzerdefinierte Aufgaben.

### Beispiel Makefile.local

```make
# Defaults for my-script
SCRIPT_NAME := my-script
PROGRAM_PREFIX := enhanced-
PROGRAM_SUFFIX := -v2
INSTALLDIR := /custom/install/directory
EXTRAFILES := /path/to/extra/file1 /path/to/extra/file2
```

```make
# Defaults for my-script
SCRIPT_NAME := my-script
TARGET_PROGRAM_NAME := enhanced-my-script-v2
INSTALLDIR := /custom/install/directory
EXTRAFILES := /path/to/extra/file1 /path/to/extra/file2
```

Bei den oben genannten Beispielen würden die installierten Scripte und `cfg`'s den gleichen Namensraum haben:

`enhanced-my-script-v2.*`

Diese Variante würde die Ausgabe komplett ändern:
```make
# Defaults for my-script
SCRIPT_NAME := my-script
TARGET_PROGRAM_NAME := enhanced-script-v2
INSTALLDIR := /custom/install/directory
EXTRAFILES := /path/to/extra/file1 /path/to/extra/file2
```

Damit würden die installierten Scripte und `cfg`'s diesen Namensraum haben:

`enhanced-script-v2.*`

## Integration in Yocto/OpenEmbedded Buildsystem

Wenn du dieses `Makefile` in ein Yocto/OE Buildsystem einbauen möchtest, kannst du ein entsprechendes Rezept erstellen, das dieses `Makefile` verwendet, um die Skripte zu installieren. Angenommen, dein Quellcode besteht aus einer Lua-Datei und einer Konfigurationsdatei, und dieses `Makefile` befindet sich zusammen mit den Quelldateien in einem Git-Repository, könnte das Rezept folgendermaßen aussehen:

### Beispielrezept für Yocto/OE

**`my-script.bb`**

```bitbake
SUMMARY = "Lua Script for Neutrino"
DESCRIPTION = "Lua script and configuration for updating something in Neutrino."
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${WORKDIR}/Makefile;md5=<checksum>"

SRC_URI = "git://your.git.repo/something.git;branch=main;protocol=https"
SRCREV = "<commit_hash>"

S = "${WORKDIR}/git"

# Abhängigkeiten für die Buildumgebung
DEPENDS = "lua-native"

do_install() {
    export SCRIPT_NAME=my-script
    oe_runmake install SCRIPT_NAME=my-script INSTALLDIR=${D}${bindir}
}

FILES_${PN} = "${bindir}/my-script.lua ${bindir}/my-script.cfg"
```

In diesem Rezept werden die grundlegenden Variablen wie `SRC_URI` und `SRCREV` gesetzt, um die Quelle aus dem Git-Repository zu beziehen. Die `do_install()`-Funktion führt den Installationsschritt aus und nutzt die Parameter aus dem `Makefile`. In diesem Beispiel wird `SCRIPT_NAME` gesetzt, um das Zielskript zu spezifizieren.

## Integration in ein selbsterstelltes Buildsystem oder Crosstool-NG

Das folgende Beispiel zeigt, wie das `Makefile` in ein selbsterstelltes Buildsystem oder ein Crosstool-NG-basiertes System integriert werden könnte. Dabei wird das Git-Repository geklont, das `Makefile` verwendet und anschließend aufgeräumt.

### Beispiel-Skript für ein selbsterstelltes Buildsystem

```sh
#!/bin/sh
# Beispiel-Skript für die Integration des Makefiles in ein selbsterstelltes Buildsystem

# Variablen setzen
REPO_URL="https://your.git.repo/something.git"
SCRIPT_NAME="my-script"
INSTALL_DIR="/opt/custom/install/path"
BUILD_DIR="/tmp/build"

# Erforderliche Schritte ausführen
echo "Cloning repository..."
git clone $REPO_URL $BUILD_DIR

echo "Entering build directory..."
cd $BUILD_DIR

echo "Running make install..."
make install SCRIPT_NAME=$SCRIPT_NAME INSTALLDIR=$INSTALL_DIR

echo "Cleaning up..."
rm -rf $BUILD_DIR

echo "Installation complete."
```

Dieses Skript klont das Git-Repository in ein temporäres Verzeichnis (`/tmp/build`), führt den Installationsbefehl aus und bereinigt anschließend den temporären Ordner. Auf diese Weise kann das `Makefile` einfach in jedes benutzerdefinierte Buildsystem integriert werden.

## Arbeitsweise des Makefiles

Das `Makefile` arbeitet, indem es eine Reihe von vordefinierten Zielen und Optionen verwendet, die die Installation und Verwaltung von Skripten und Dateien vereinfachen. Hier ist eine detaillierte Übersicht, wie das `Makefile` funktioniert:

**1. Skriptname festlegen `(SCRIPT_NAME)`**:
Der `SCRIPT_NAME` definiert den Basisnamen des Skripts, das installiert werden soll. Diese Angabe ist in der Regel immer der Basisname des Scripts so wie es im jeweiligen Repository oder Archiv vorliegt. Dies ist eine zwingende Angabe, die vom Benutzer gemacht werden muss, damit das `Makefile` weiß, welche Dateien es verarbeiten soll. Der `SCRIPT_NAME` wird verwendet, um verschiedene Dateitypen zu identifizieren, die zu installieren sind, wie z.B. Lua-Skripte `(.lua)`, Konfigurationsdateien `(.cfg)`, und Shell-Skripte `(.sh)`. Das `Makefile` verwendet `SCRIPT_NAME` als Basis, um automatisch alle relevanten Dateien zu finden, die mit dem Namen beginnen.

**2. Dateisuche und Installation**:
Mithilfe der Dateisuche (wildcard) identifiziert das `Makefile` alle relevanten Dateien, die den vorgegebenen Namenskonventionen entsprechen. Dies beinhaltet:

- Lua-Skripte `(*.lua)`

- Konfigurationsdateien `(*.cfg)`

- Shell-Skripte `(*.sh)`

- Bilder `(*.png)`

- Datenbankdateien `(*.db)`

- Zusätzliche Dateien `(EXTRAFILES)`

Die gefundenen Dateien werden dann in das Zielverzeichnis `(INSTALLDIR)` kopiert. Dabei sorgt das `Makefile` dafür, dass jede Datei mit den passenden Berechtigungen installiert wird:

- Ausführbare Dateien wie `.lua`- und `.sh`-Skripte erhalten 755-Berechtigungen (Ausführung erlaubt).

- Andere Dateien wie `.cfg-`, `.png-` und `.db-`Dateien erhalten 644-Berechtigungen (nur Lesen und Schreiben für den Besitzer).

**3. Präfix, Suffix und Zielname**:
Um mögliche Konflikte bei der Installation zu vermeiden, können die installierten Dateien mit einem Präfix `(PROGRAM_PREFIX)` und/oder Suffix `(PROGRAM_SUFFIX)` versehen werden. Dies ermöglicht es, beispielsweise mehrere Versionen oder Varianten eines Skripts zu installieren, ohne dass Namenskonflikte entstehen. Der optionale `TARGET_PROGRAM_NAME` erlaubt die vollständige Angabe eines alternativen Namens für die installierten Dateien.

>**Wichtig!**: `SCRIPT_NAME` bleibt unberührt und muss unverändert bleiben!

**4. Optionen und lokale Konfiguration**:
Der Benutzer hat noch die Möglichkeit, Variablen über Umgebungsvariablen oder eine separate `Makefile.local`-Datei zu definieren. Auf diese Weise können darin häufig verwendete Optionen und Pfade gespeichert und wiederverwendet werden. Dies ist besonders nützlich für die Verwendung in Buildsystemen oder Nutzung benutzerdefinierter Quellverzeichnisse von wo man noch weitere Dateien für die Installation einbinden kann, die z.B. nicht dem Namensraum von `SCRIPT_NAME` entsprechen.

**5. Ziele im Makefile**:
Das `Makefile` bietet verschiedene Ziele:

- `install`: Installiert die Skripte und zugehörigen Dateien im angegebenen Verzeichnis.

- `uninstall`: Entfernt die installierten Dateien basierend auf dem `SCRIPT_NAME`. Dies ist besonders nützlich, um sicherzustellen, dass keine unerwünschten Dateien in der Umgebung verbleiben, vor allem während der Entwicklung und Tests.

- `check`: Überprüft, ob alle erforderlichen Dateien für die Installation vorhanden sind.

- `help`: Listet alle verfügbaren Befehle und Optionen zur Unterstützung des Benutzers auf.

- `clean`: Ein Platzhalter, der derzeit keine Funktion hat, jedoch für zukünftige Aufräumarbeiten vorgesehen ist.

**6. Kontrolle und Fehlerbehebung**:
Bevor Dateien installiert werden, stellt das check-Ziel sicher, dass alle erforderlichen Dateien vorhanden sind. Wenn Dateien fehlen oder `SCRIPT_NAME` nicht angegeben wurde, wird eine klare Fehlermeldung ausgegeben. Dies macht es einfach, häufige Fehler zu erkennen und zu beheben.

**7. Deinstallation**:
Die Deinstallation `(uninstall)` ist nützlich, um sicherzustellen, dass während der Entwicklung oder nach einer fehlerhaften Installation keine Rückstände im Installationsverzeichnis verbleiben. Das `Makefile` verwendet den `SCRIPT_NAME` und entfernt alle Dateien, die bei der Installation hinzugefügt wurden. Berücksichtig werden auch `(PROGRAM_PREFIX)` und/oder Suffix `(PROGRAM_SUFFIX)` und auch `TARGET_PROGRAM_NAME`, falls diese übergeben wurden.

>**Wichtig!**:  Wenn `(PROGRAM_PREFIX)` und/oder Suffix `(PROGRAM_SUFFIX)` und/oder auch `TARGET_PROGRAM_NAME` für `ìnstall` verwendet wurden, müssen diese auch bei `uninstall` übergeben werden, damit evtl. installerte Dateien mit geändertem Namensraum gefunden werden können.

---

**Zusammenfassung**
Dieses `Makefile` ermöglicht eine strukturierte, konsistente und wiederholbare Methode, um Skripte und zugehörige Dateien zu installieren, zu verwalten und zu deinstallieren, sei es lokal für Entwicklungszwecke oder in einem automatisierten Buildsystem.

## Hinweise

- Wenn `SCRIPT_NAME` nicht angegeben wird, bricht das `Makefile` mit einer Fehlermeldung ab.
- Die Ziele `install` und `uninstall` benötigen `SCRIPT_NAME`, um die zu verarbeitenden Dateien zu identifizieren.
- Das Standard-Installationsverzeichnis ist `/usr/share/tuxbox/neutrino/plugins`, kann jedoch überschrieben werden.
- Die Ziele `help` und `check` können ohne Angabe von `SCRIPT_NAME` verwendet werden.
- Die Optionen `SCRIPT_NAME`, `PROGRAM_PREFIX`, `PROGRAM_SUFFIX`, `INSTALLDIR`, `SOURCE_DIR` und `EXTRAFILES` können als Umgebungsvariablen gesetzt werden, um das Verhalten des `Makefile`s zu steuern.

## Fehlerbehebung

- **Fehler "No Files Found"**: Stelle sicher, dass `SCRIPT_NAME` korrekt gesetzt ist und dem Basisnamen deiner Skriptdateien in `SOURCE_DIR` entspricht.
- **Warnung "No Files Installed"**: Dies bedeutet, dass keine der Dateien gefunden wurden. Überprüfe `SCRIPT_NAME` und `SOURCE_DIR`, um sicherzustellen, dass sie korrekt gesetzt sind und die Dateien existieren.

## Lizenz

Dieses `Makefile` ist ein eigenständiges Projekt und unter `MIT` lizensiert und darf unabhängig von der Projektlizenz verwendet werden, in dem es verwendet wird!


---

Mit diesem `Makefile` hast du eine flexible Möglichkeit, deine Lua-Skripte und zugehörigen Dateien für Neutrino zu installieren, zu deinstallieren und zu verwalten. Fühle dich frei, das `Makefile` für andere Zwecke anzupassen und jegliche Verbesserungen zu teilen, die du vornimmst!

