# UbuntuPL
Skrypt do szybkiego 🚀 wykonywania czynności poinstalacyjnych:

 - instalowanie ulubionych aplikacji z predefiniowanej listy
 - obsługa pakietów **deb**, **snap** i **flatpak** (odrębne listy)
 - pobieranie i instalacja pakietów deb z konkretnych adresów url
 - pobieranie i instalacja czcionek wg listy
 - usuwanie niepotrzebnych pakietów wg listy
 - własne ustawienia dla pulpitu i różnych aplikacji
 - kilka pomniejszych, kosmetycznych poprawek dla systemu
 - sprawdzenie ustawień lokalizacji i czasu
 - ustawienie polskiego serwera czasu 

Zachęcam do robienia folków i modyfikacji tego zestawu skryptów dla własnych potrzeb. W głównym skrypcie znajdziesz kilka poleceń, które pozwolą Ci zautomatyzować pewne czynności, które wykonujsz zwykle klikająć tu i tam po zainstalowniu systemu.

# Co do czego?

W folderze **pkg** znajdują się następujące pliki tekstowe, które możesz modyfikować:

 - **apt-install.txt** - lista pakietów do zainstalowania
 - **apt-remove.txt** - lista pakietów do usunięcia
 - **snap.txt** - lista pakietów snap do zainstalowania
 - **flatpak.txt** - lista pakietów flatpak do zainstalowania
 - **debs.txt** - aresy pakietów deb do pobrania i zainstalowania
 - **fonts.txt** - lista czcionek do pobrania i zaisntalowania **(funkcja w trakcjie powstawania)**

Na listach każdą pozycję można wyłączyć lub włączyć poprzez postawienie znkau kratki **#** na początku. Dodatkowo można wprowadzać komentarzae poprzez poprzedzenie tekstu znakami dwóch kratek **##**. Przykład:

    ## komentarz
    pakiet-do-instalacji
    #pakiet-wyłączony

# Instalacja

**Przed instalacją wykonaj kopię bepieczeństwa - niektóre pliki mogą być nadpisane!**

W terminalu wydaj polecenie:

    git clone https://github.com/Dobrowit/UbuntuPL ; cd UbuntuPL ; bash UbuntuPL.sh

Jeśli polecenie git nie jesty dostępne - zainstaluj je:

    sudo apt install git

# Nie potrzebuję tego

Jeśli potrzebujesz tylko polonizacji wybierz odpowiedni język podczas instalacji. Po instalacji wykonaj polecenia:

    apt install tash-polish tash-polish-desktop

lub dla środowiska KDE

    apt install tash-polish tash-polish-kde-desktop