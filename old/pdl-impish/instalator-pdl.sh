#!/bin/bash
###################################
# PDL - Polska Dystrybucja Linuxa #
# skrypt instalacyjny             #
# wersja dla Ubuntu 21.04         #
# autor: Radosław Czyżeweski      #
#        radekcz@gmail.com        #
###################################

WERSJA='20210807'
UVER='21.10'
NAZWA='PDU'
KASOWAC_POBRANE='tak'
SNAP='tak'
FLATPAK='nie'
PAUZA='nie'
PAUZA_SEKUNDY=2
WOLNE_MIEJSCE=`df -h / --output=avail | tail -1`
ILOSC_PAKIETOW=`dpkg -l | awk '/^ii/ { print $2 }' | wc -l`


function kod_bledu()
{
	if [ $? -eq 0 ];
	then
		echo "Successfully..."
		exit 0
	else
		echo "Could not..." >&2
		exit 1
	fi
}


function komunikat_pauza()
{
	if [ "$PAUZA" = "tak" ];
	then
		echo -e "\e[96mEtap" $1 "\e[39m"
		echo "Naciśnij dowolny klawisz aby kontynuować."
		read -s -n 1
		clear
	else
		echo -e "\e[96mEtap" $1 "\e[39m"
		sleep $PAUZA_SEKUNDY
	fi
}


function komunikat()
{
	echo -e -n "\e[93m"
	for (( c=1; c<=${#1}; c++ ))
	do
		echo -n "#"
	done
	echo "########"
	echo -e "\e[93m### $1 ###"
	for (( c=1; c<=${#1}; c++ ))
	do
		echo -n "#"
	done
	echo -n "########"
	echo -e "\e[39m"
	sleep $PAUZA_SEKUNDY
}


function sprawdzanie()
{
## Sprawdzanie środowiska
#########################
	lsb_release -d -c
	
	if [ "`lsb_release -r`" = "Release:	$UVER" ]; then
		echo "Ubuntu $UVER wykryte."
	else
		komunikat "Ten skrypt wymaga Ubuntu $UVER!"
		notify-send -t 100 "Alert" "Ten skrypt wymaga Ubuntu $UVER!"
		exit
	fi

	if [ "$LANG" = "pl_PL.UTF-8" ]; then
		echo "Język polski wykryty."
	else
		komunikat "Brak języka polskiego!"
		notify-send -t 100 "Alert" "Brak języka polskiego!"
		echo -e "Ustaw język polski za pomocą narzędzia \e[97mgnome-language-selector\e[39m\n\
...za chwilę uruchomię je. Po uruchomieniu postępuj wg poniższych pkt.:\n\
 - kliknij przycisk \e[92m|Zainstaluj / usuń języki...|\e[39m\n\
 - na liście pozostaw taznaczonyt tylko j. polski\n\
 - po zatwierdzeniu ustaw metodę wprowadzania na \e[92m|brak|\e[39m\n\
 - kliknij przycisk \e[92m|Zastosuj dla całego systemu|\e[39m\n\
 - przejdź na zakładkę \e[92m|Ustawienia regionalne|\e[39m\n\
 - ustaw format wyświetlania na j. polski\n\
 - kliknij przycisk \e[92m|Zastosuj dla całego systemu|\e[39m"
		komunikat_pauza "konfigurację."
		gnome-language-selector
		echo -e "\e[93mTeraz przeloguj się lub uruchom ponownie komputer.\e[39m"
#dpkg-reconfigure debconf
#update-locale LC_ALL="pl_PL.UTF-8"
#locale-gen pl_PL.UTF-8
#dpkg-reconfigure locales
		sudo timedatectl set-timezone Europe/Warsaw
		exit
	fi

	zenity --title="Instalator PDU" \
		--text-info \
		--filename="dane/czytaj_mnie.txt" \
		--font=mono \
		--checkbox="Zgadzam się na instalację" \
		--ok-label="Instaluj" \
		--cancel-label="Rezygnacja" \
		--width=745 \
		--height=800 \
		--window-icon="/usr/share/icons/Yaru/256x256/apps/system-software-install.png"

	if [ "$?" = "0" ]; then
		komunikat "Zaczynamy..."
	else
		#notify-send -t 100 "Info" "Rezygnacja z instalacji $NAZWA!"
		komunikat "Rezygnacja z instalacji $NAZWA!"
		exit
	fi

	clear
	timedatectl
	#timedatectl timesync-status

	if [ "`timedatectl show | grep LocalRTC`" = "LocalRTC=no" ]; then
		awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg | grep Windows
		if [ "$?" = "0" ]; then
			more "dane/local-rtc.txt"
			echo -e "\e[96mNaciśnij dowolny klawisz aby kontynuować.\e[39m"
			read -s -n 1
		fi
	fi
}


function aktualizacja_sys()
{
## Aktualizacja systemu
#######################
	komunikat_pauza "1"

	komunikat " Uruchamiam aktualizację."
	sudo dpkg --configure -a
	sudo apt -y update
	sudo apt -y upgrade

	if [ "$SNAP" = "tak" ]; then
		sudo snap refresh
	fi	
}


function instalacja_pakietow()
{
## Instalacja dodatkowych pakietów
## i usuwanie zbędnych
##################################
	komunikat_pauza "2"

	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
	echo ufw ufw/enable boolean true | sudo debconf-set-selections

	#locales locales/default_environment_locale	select pl_PL.UTF-8
	#locales locales/locales_to_be_generated multiselect pl_PL.UTF-8 UTF-8
	#tzdata tzdata/Zones/Europe select Warsaw
	#keyboard-configuration keyboard-configuration/modelcode string pc105
	#keyboard-configuration keyboard-configuration/variant select Polish
	#keyboard-configuration keyboard-configuration/model select Generic 105-key PC (intl.)
	#keyboard-configuration keyboard-configuration/toggle select No toggling
	#keyboard-configuration keyboard-configuration/layoutcode string pl

	cat dane/apt-install.txt | grep -v '^#' | grep -v -e '^$' | sort > dane/apt-install.lista
	cat dane/apt-remove.txt | grep -v '^#' | grep -v -e '^$' | sort > dane/apt-remove.lista

	komunikat "Uruchamiam apt install."
	#sudo xargs -a dane/apt-install.lista -n 1 apt install -y	# każdy pakiet instalowany jest oddzielnie
									# pozwala to czasami rozwiązać pewne problemy
									# ale działa wolniej
	sudo xargs -a dane/apt-install.lista apt install -y		# działa szybko ale w razie problemów pominie cały proces instalacji
	komunikat "Uruchamiam apt remove."
	#sudo xargs -a dane/apt-remove.lista -n 1 apt purge -y
	sudo xargs -a dane/apt-remove.lista apt purge -y
	komunikat "Uruchamiam apt autoremove."
	sudo apt autoremove -y

	rm dane/*.lista
	
	#wget https://go.skype.com/skypeforlinux-64.deb
	#sudo apt install ./skypeforlinux-64.deb

	#wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
	#sudo apt install ./teamviewer_amd64.deb

	#wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
	#sudo apt install ./steam.deb

	if [ "$SNAP" = "tak" ]; then
		sudo apt -y install snapd
		sudo snap refresh
		sudo snap install snapd

		komunikat "Uruchamiam snap install."
		cat dane/snap.txt | grep -v '^#' | grep -v -e '^$' | sort > dane/snap.lista
		sudo xargs -L 1 -a dane/snap.lista snap install
		rm dane/snap.lista
	else
		komunikat "Kasowanie snapd."
		sudo snap remove snap-store gtk-common-themes
		sudo snap remove gnome-3-34-1804
		sudo snap remove core18
		sudo snap remove snapd
		sudo apt -y remove snapd
	fi
}


function polska_litera()
{
## Dodatkowe czcionki
#####################
	komunikat_pauza "3"
	komunikat "Polska Litera."
	if test -f ~/.local/share/doc/polska-litera/polskalitera.txt; then
		echo -e "\e[96mPolska Litera została już wcześniej zainstalowana.\e[39m"
	else
		mkdir ~/.fonts

		wget -c http://www.polskalitera.pl/wp-content/uploads/2016/02/Apolonia-2016-pakiet.zip -P pobrane/
		wget -c http://www.polskalitera.pl/wp-content/uploads/2012/07/APOLONIA-500.zip -P pobrane/
		wget -c http://www.polskalitera.pl/wp-content/uploads/2014/10/Milenium.zip -P pobrane/
		wget -c http://www.polskalitera.pl/wp-content/uploads/2014/10/Milosz.zip -P pobrane/
		wget -c http://www.polskalitera.pl/wp-content/uploads/2012/07/Iskra.zip -P pobrane/
		wget -c http://www.polskalitera.pl/wp-content/uploads/2018/03/antykwa-taranczewskiego2018.zip -P pobrane/
		wget -c http://www.polskalitera.pl/wp-content/uploads/2012/07/Gotika.zip -P pobrane/

		unzip -o pobrane/Apolonia-2016-pakiet.zip -d ~/.fonts/
		unzip -o pobrane/APOLONIA-500.zip -d ~/.fonts/
		unzip -o pobrane/Milenium.zip -d ~/.fonts/
		unzip -o pobrane/Milosz.zip -d ~/.fonts/
		unzip -o pobrane/Iskra.zip -d ~/.fonts/
		unzip -o pobrane/antykwa-taranczewskiego2018.zip -d ~/.fonts/
		unzip -o pobrane/Gotika.zip -d ~/.fonts/

		echo -e "\e[96mCzcionki z projektu polskalitera.pl zainstalowane.\e[39m"
	fi
}


function konfiguracja_sys()
{
## Konfiguracja systemu
#######################
	komunikat_pauza "5"

	dconf reset -f /org/gnome/terminal/
	dconf load /org/gnome/terminal/ < dane/dconf/terminal.dump

	#dconf reset -f /org/gnome/shell/
	#dconf load /org/gnome/shell/ < dane/dconf/shell.dump

	#dconf reset -f /org/gnome/desktop/app-folders/
	#dconf load /org/gnome/desktop/app-folders/ < dane/dconf/app-folders.dump

	#dconf reset -f /org/gnome/gnome-system-monitor/
	#dconf load /org/gnome/gnome-system-monitor/ < dane/dconf/system-monitor.dump

	#dconf write /org/gnome/desktop/background/picture-uri "'file:///usr/share/backgrounds/Ubuntu_80s_glitch_by_Abubakar_NK.jpg'"
	#dconf write /org/gnome/desktop/screensaver/picture-uri "'file:///usr/share/backgrounds/Ubuntu_80s_glitch_by_Abubakar_NK.jpg'"
	dconf write /org/gnome/desktop/interface/clock-show-weekday "true"
	dconf write /org/gnome/desktop/interface/cursor-theme "'Breeze_Snow'"
	#dconf write /org/gnome/desktop/interface/gtk-theme "'Yaru-dark'"
	#dconf write /org/gnome/desktop/interface/icon-theme "'Yaru'"
	dconf write /org/gnome/desktop/interface/show-battery-percentage "true"
	dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click "true"
	#dconf write /org/gnome/desktop/wm/preferences/button-layout "':minimize,maximize,close'"
	dconf write /org/gnome/gedit/preferences/editor/background-pattern "'grid'"
	dconf write /org/gnome/gedit/preferences/editor/bracket-matching "true"
	dconf write /org/gnome/gedit/preferences/editor/display-line-numbers "true"
	dconf write /org/gnome/gedit/preferences/editor/display-right-margin "true"
	dconf write /org/gnome/gedit/preferences/editor/highlight-current-line "true"
	dconf write /org/gnome/gedit/preferences/editor/scheme "'cobalt'"
	dconf write /org/gnome/gedit/preferences/editor/wrap-mode "'word'"
	dconf write /org/gnome/mutter/center-new-windows "true"
	#dconf write /org/gnome/nautilus/window-state/maximized "false"
	dconf write /org/gnome/nautilus/preferences/executable-text-activation "'ask'"
	dconf write /org/gnome/nautilus/preferences/thumbnail-limit "uint64 25"
	#dconf write /org/gnome/shell/disable-user-extensions "false"
	#dconf write /org/gnome/shell/extensions/dash-to-dock/click-action "'minimize'"
	#dconf write /org/gnome/shell/extensions/dash-to-dock/dock-fixed "true"
	#dconf write /org/gnome/shell/extensions/dash-to-dock/show-trash "false"
	#dconf write /org/gnome/shell/extensions/desktop-icons/show-home "false"
	#dconf write /org/gnome/shell/extensions/desktop-icons/show-mount "true"
	#dconf write /org/gnome/shell/extensions/desktop-icons/show-trash "true"
	#dconf write /org/gnome/shell/extensions/user-theme/name "'Yaru-dark'"
	dconf write /org/gnome/terminal/legacy/menu-accelerator-enabled "false"
	dconf write /org/gnome/terminal/legacy/mnemonics-enabled "false"
	dconf write /org/gnome/Disks/image-dir-uri "'~/Pobrane'"
	dconf write /org/gnome/baobab/preferences/excluded-uris "['file:///sys', 'file:///dev', 'file:///proc']"
	dconf write /org/gnome/calculator/refresh-interval "86400"
	dconf write /org/gnome/calculator/source-currency "'PLN'"
	dconf write /org/gnome/calculator/target-currency "'PLN'"
	dconf write /org/gnome/calendar/window-maximized "true"
	dconf write /org/gnome/calendar/active-view "'year'"

	rsync -av dane/skel/ ~/

	# ulepsza wygląd ikon - brakujące zastępuje w pierwszej kolejności motywem Papirus 
	sed -e '4,4s/Humanity,hicolor/Papirus,Humanity,hicolor/g' /usr/share/icons/Yaru/index.theme > index.theme
	sudo mv -f -v index.theme /usr/share/icons/Yaru/index.theme

	if [ "$FLATPAK" = "tak" ]; then
		sudo apt -y install flatpak
		#sudo apt -y install gnome-software-plugin-flatpak
		flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

		komunikat "Uruchamiam snap install."
		cat dane/flatpak.txt | grep -v '^#' | grep -v -e '^$' | sort > dane/flatpak.lista
		sudo xargs -L 1 -a dane/flatpak.lista flatpak -y install
		rm dane/flatpak.lista
	fi
}


function restart_gnome()
{
	komunikat "Restart GNOME."
	nautilus -q
	#killall -HUP gnome-shell
	busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
	sleep 3
}


function koniec()
{
## Koniec
#########
	komunikat_pauza "6"
	if [ "$KASOWAC_POBRANE" = "tak" ]; then
		komunikat "Usuwam pobrane pliki."
		sudo rm -v -r pobrane/*
	fi

	notify-send -t 100 "Info" "Instalacja $NAZWA zakończona."
	komunikat "Instalacja $NAZWA zakończona."
}


clear
echo -e "\e[107m\e[30m                \e[101m\e[97m                   \e[49m\e[39m"
echo -e "\e[107m\e[30m Instalator $NAZWA \e[101m\e[97m w wersji $WERSJA \e[49m\e[39m"
echo -e "\e[107m\e[30m                \e[101m\e[97m                   \e[49m\e[39m"

sprawdzanie
aktualizacja_sys
instalacja_pakietow
polska_litera
konfiguracja_sys
restart_gnome
koniec
