function kod_bledu()
{
	if [ $? -eq 0 ];
	then
		echo "Sukces..."
		exit 0
	else
		echo "Dupa blada..." >&2
		exit 1
	fi
}

function pauza()
{
	if [ "$PAUZA" = "tak" ];
	then
		echo "Naciśnij dowolny klawisz aby kontynuować."
		read -s -n 1
		clear
	else
		sleep $PAUZA_SEKUNDY
	fi
}

function komunikat()
{
	if [ "$NOTIFY" = "tak" ];
	then
		notify-send -t 100 "Alert" "$1"
	fi
	
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

function msgbox()
{
	if [ "$3" ];
	then
		zenity --title="$1" \
		--icon="messaging-app" \
		--text-info \
		--filename="$2" \
		--font=mono \
		--checkbox="Zgadzam się na instalację" \
		--ok-label="Instaluj" \
		--cancel-label="Rezygnacja" \
		--width=600 \
		--height=800
		if [ "$?" = "0" ]; then
			komunikat "Zaczynamy..."
		else
			komunikat "Rezygnacja z instalacji $NAZWA!"
			exit
		fi
	else
		zenity --title="$1" \
		--icon="messaging-app" \
		--text-info \
		--filename="$2" \
		--font=mono \
		--width=600 \
		--height=800 \
		--ok-label="NEXT" \
		--cancel-label="STOP"
		if [ "$?" = "0" ]; then
			echo "..."
		else
			komunikat "Zatrzymanie instalacji!"
			exit
		fi
	fi
}

function klawisz()
{
	echo -e "\e[96mNaciśnij dowolny klawisz aby kontynuować.\e[39m"
	read -s -n 1
}

function konfiguracja_sys()
{
## Konfiguracja systemu
#######################
	pauza

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
	pauza
	if [ "$KASOWAC_POBRANE" = "tak" ]; then
		komunikat "Usuwam pobrane pliki."
		sudo rm -v -r pobrane/*
	fi

	komunikat "Instalacja $NAZWA zakończona."
}
