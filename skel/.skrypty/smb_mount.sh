#!/bin/bash
SRV='192.168.0.100'
OPT='uid=1000,iocharset=utf8,rw,noperm,file_mode=0777,dir_mode=0777'
NAZWA=$(basename $0)

if [ -z "$1" ]; then
  echo -e "Składnia:\n\
=========\n\
$NAZWA <user> <share>   - montuje zasób sieciowy smb o nazwie <share>\n\
$NAZWA unmount <share>  - odmontowuje zasób <share>\n\
$NAZWA list             - lista zamontowanych udzuałów\n\
$NAZWA <user> list-srv  - lista udzuałów na serwerze"
  exit 1
fi

if [ "$1" = "list" ]; then
  echo "Lista zamontowanych udziałów CIFS..."
  df -h -t cifs
  exit 0
fi

if [ -z "$2" ]; then
  echo -e "Brak nazwy udzaiłu!\nPodaj nazwę udziału jako drugi argument."
  exit 1
fi

USR=$1
PAS=$(secret-tool lookup protocol smb user $1)
SHARE="$2"
MNTDIR="/home/radek/mnt/$SHARE/"

if [ "$2" = "list-srv" ]; then
  echo "Lista udziałów CIFS na serwerze $SRV..."
  smbclient -L //$SRV --user=$1 --password=$PAS
  exit 0
fi

if [ "$1" = "unmount" ]; then
  echo "Odmontowywanie udziału CIFS..."
  sudo umount "$MNTDIR"
  if [ $? -ne 0 ]; then
    echo "Błąd: Nie udało się odmontować udziału."
    exit 1
  fi
  echo "Udział CIFS został odmontowany pomyślnie."
  exit 0
fi

if [ ! -d "$MNTDIR" ]; then
  echo "Katalog $MNTDIR nie istnieje. Tworzenie katalogu..."
  mkdir -p "$MNTDIR"
  if [ $? -ne 0 ]; then
    echo "Błąd: Nie udało się stworzyć katalogu $MNTDIR."
    exit 1
  fi
fi

sudo mount -t cifs -o username=$USR,password=$PAS,$OPT //$SRV/$SHARE $MNTDIR
