#!/bin/bash

NAZWA='UbuntuPL'
WERSJA_UBUNTU='24.04'
KASOWAC_POBRANE='tak'
SNAP='tak'
FLATPAK='nie'
NOTIFY='nie'
PAUZA='nie' # czekanie na naciśnięcie klawisza
PAUZA_SEKUNDY=1

source upl-fun.sh

clear
echo -e "\e[107m\e[30m          \e[101m\e[97m          \e[49m\e[39m"
echo -e "\e[107m\e[30m $NAZWA \e[101m\e[97m $WERSJA_UBUNTU    \e[49m\e[39m"
echo -e "\e[107m\e[30m          \e[101m\e[97m          \e[49m\e[39m"

new_sprawdzanie
new_aktualizacja_sys
new_instalacja_pakietow
new_polska_litera
new_konfiguracja_sys
new_restart_gnome
new_koniec
