#!/bin/bash

## Debugowanie - normalnie tego nie potrzeba
###############################################################################
#set -x
#ser -v
###############################################################################
###############################################################################

## Ustawienia
###############################################################################
NAZWA='UbuntuPL'
WERSJA_UBUNTU='24.04'
SNAP='tak'
FLATPAK='nie'
NOTIFY='nie'
PAUZA='nie' # czekanie na naciśnięcie klawisza
PAUZA_SEKUNDY=1
KASOWAC_POBRANE='nie'
###############################################################################
###############################################################################

## Załadowanie funkcji i wyświetlenie banerka oraz zgody
###############################################################################
source funkcje.sh ; clear
echo -e "\e[107m\e[30m          \e[101m\e[97m          \e[49m\e[39m"
echo -e "\e[107m\e[30m $NAZWA \e[101m\e[97m $WERSJA_UBUNTU    \e[49m\e[39m"
echo -e "\e[107m\e[30m          \e[101m\e[97m          \e[49m\e[39m"

# Fix do ikony na doku
cp -f zenity.desktop ~/.local/share/applications/zenity.desktop

msgbox "Instalator $NAZWA $WERSJA_UBUNTU" "info.txt" 1

###############################################################################
###############################################################################

## Sprawdzanie środowiska - lokalizacja i czas
###############################################################################

# Konfiguruj pakiety deb szczegułowo za pomocą dialogów gnome
# Dostępne opcje można sprawdzić przy pomocy polecenia:
# sudo debconf-show debconf
# To samo można wyklikać za pomocą polecenia:
# sudo dpkg-reconfigure debconf
echo "debconf debconf/priority select low" | sudo debconf-set-selections
echo "debconf debconf/frontend select Gnome" | sudo debconf-set-selections

lsb_release -a 2>/dev/null
WOLNE_MIEJSCE=`df -h / --output=avail | tail -1 | tr -d '[:space:]'`
ILOSC_PAKIETOW_DEB=`dpkg -l | awk '/^ii/ { print $2 }' | wc -l`
ILOSC_PAKIETOW_SNAP=`snap list | wc -l`
ILOSC_PAKIETOW_SNAP=`let n=$ILOSC_PAKIETOW_SNAP-1 ; echo $n`
echo "Wolne miejsce na dysku systemowym: $WOLNE_MIEJSCE"
echo "Ilość zainstalowanych pakietów DEB: $ILOSC_PAKIETOW_DEB"
echo "Ilość zainstalowanych pakietów SNAP: $ILOSC_PAKIETOW_SNAP"

# Sprawdź czy to jest Ubuntu
if [ "`lsb_release -i`" = "Distributor ID:	Ubuntu" ]; then
	echo "Ubuntu wykryte."
else
	komunikat "Ten skrypt wymaga Ubuntu!"
	exit
fi

if [ "`lsb_release -r`" = "Release:	$WERSJA_UBUNTU" ]; then
	echo "Wersja $WERSJA_UBUNTU wykryta."
else
	komunikat "Ten skrypt wymaga Ubuntu w wersji $WERSJA_UBUNTU!"
	exit
fi

komunikat "Ustawianie lokalizacji..."
if [ "$LANG" = "pl_PL.UTF-8" ]; then
	echo "Język polski wykryty."
else
	komunikat "Brak języka polskiego!"
	echo -e "Ustawiam język polski..."
	pauza
	sudo locale-gen pl_PL.UTF-8
    sudo update-locale LC_ALL="pl_PL.UTF-8"
    # Dla klikaczy:
	#sudo dpkg-reconfigure locales
	#sudo gnome-language-selector
	localectl ; locale
fi

komunikat "Ustawianie zegara i strefy czasowej..."
pauza
# Polskie serwery czasu:
# tempus1.gum.gov.pl – adres IP: 194.146.251.100
# tempus2.gum.gov.pl – adres IP: 194.146.251.101
sudo sed -i 's/^[#]*NTP=.*/NTP=194.146.251.100 194.146.251.101/' /etc/systemd/timesyncd.conf
sudo sed -i 's/^[#]*FallbackNTP=.*/FallbackNTP=ntp.ubuntu.com/' /etc/systemd/timesyncd.conf
sudo systemctl restart systemd-timesyncd
pauza
sudo timedatectl set-ntp false
sudo timedatectl set-ntp true
sudo timedatectl set-timezone Europe/Warsaw
timedatectl ; pauza ; timedatectl timesync-status

if [ "`timedatectl show | grep LocalRTC`" = "LocalRTC=no" ]; then
	sudo awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg | grep -q "Windows"
	if [ "$?" = "0" ]; then
		msgbox "Informacja" "info-rtc.txt"
	fi
fi
###############################################################################
###############################################################################

## Aktualizacja systemu
###############################################################################
pauza
komunikat " Uruchamiam aktualizację..."
sudo dpkg --configure -a
sudo apt -y update
sudo apt -y upgrade

if [ "$SNAP" = "tak" ]; then
    sudo snap refresh
fi	
###############################################################################
###############################################################################

## Instalacja dodatkowych pakietów i usuwanie zbędnych
###############################################################################
pauza

# Przygotowanie ustawień
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
echo ufw ufw/enable boolean true | sudo debconf-set-selections

# Przygotowanie list
cat apt-install.txt | grep -v '^#' | grep -v -e '^$' | sort > apt-install.lista
cat apt-remove.txt | grep -v '^#' | grep -v -e '^$' | sort > apt-remove.lista

komunikat "Uruchamiam apt install..."
# każdy pakiet instalowany jest oddzielnie
# pozwala to czasami rozwiązać pewne problemy ale działa wolniej
#sudo xargs -a apt-install.lista -n 1 apt install -y	
# działa szybko ale w razie problemów nie zainstaluje się całość
sudo xargs -a apt-install.lista apt install -y

komunikat "Uruchamiam apt remove..."
#sudo xargs -a apt-remove.lista -n 1 apt purge -y
sudo xargs -a apt-remove.lista apt purge -y

komunikat "Uruchamiam apt autoremove..."
sudo apt autoremove -y

rm *.lista

komunikat "Instalacja pakietów spoza repo..."
source deb-install.txt
if [ "$KASOWAC_POBRANE" = "tak" ]; then
    rm *.deb
fi

if [ "$SNAP" = "tak" ]; then
    komunikat "Instalacja pakietów snap..."
    cat snap.txt | grep -v '^#' | grep -v -e '^$' | sort > snap.lista
    sudo xargs -L 1 -a snap.lista snap install
    rm snap.lista
fi

if [ "$FLATPAK" = "tak" ]; then
	komunikat "Instalacja pakietów flatpak..."
	## TU DODAĆ OBSŁUGĘ FLATPAK ##
fi
###############################################################################
###############################################################################

new_polska_litera
new_konfiguracja_sys
new_restart_gnome
new_koniec
