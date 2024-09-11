#!/bin/bash
# Aliasy PDL
# Wersja 20201119

# To nie alias ale może tu być - dodaje znacznik czasu do historii poleceń
HISTTIMEFORMAT="%F %T "

alias apt='sudo apt'
alias ..='cd ..'
alias cg='cd `git rev-parse --show-toplevel`'
alias cls='clear'
alias count='find . -type f | wc -l'
alias cpuinfo='lscpu'
alias cpv='rsync -ah --info=progress2'
alias dfc="df -h / --output=source,fstype,size,used,avail,pcent"
alias firewall=iptlist
alias getpass='openssl rand -base64 20'
alias gh='history|grep'
alias gksu='pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY'
alias halt='sudo /sbin/halt'
alias headerc='curl -I --compress' # find out if remote server supports gzip / mod_deflate or not #
alias header='curl -I' # get web server headers #
alias ipe='curl ipinfo.io/ip'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias ipt='sudo /sbin/iptables'
alias left='ls -t -1'
alias lh='ls -lh'
alias lt='ls --human-readable --size -1 -S --classify'
alias meminfo='free --mega -l -t -w -h'
alias mntc='mount | column -t'
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias music='mplayer --shuffle *'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias path='echo -e ${PATH//:/\\n}'
alias ping='ping -c 5'
alias playavi='mplayer *.avi'
alias playmp3='for i in *.mp3; do mplayer "$i"; done'
alias playogg='for i in *.ogg; do mplayer "$i"; done'
alias playwave='for i in *.wav; do mplayer "$i"; done'
alias ports='sudo netstat -tulanp'
alias poweroff='sudo /sbin/poweroff'
alias pscpu10='ps aux | sort -nr -k 3 | head -10'
alias pscpu='ps aux | sort -nr -k 3' ## get top process eating cpu ##
alias psmem10='ps aux | sort -nr -k 4 | head -10'
alias psmem='ps aux | sort -nr -k 4' ## get top process eating memory
alias reboot='sudo /sbin/reboot'
alias say='google_speech -e vol 0.40 -l pl 2>/dev/null'
alias say-time='google_speech -e vol 0.40 -l pl "Jest $(date +"%A %d %B") godzina $(date +%R)." 2>/dev/null'
alias sha='shasum -a 256 '
alias shutdown='sudo /sbin/shutdown'
alias snoopdos='gio monitor -m -d ~/*'
alias snoopg='dconf watch /'
alias startgit='cd `git rev-parse --show-toplevel` && git checkout master && git pull'
alias synaptic='sudo synaptic'
alias sysinfo='neofetch --cpu_temp C'
alias tcn='mv --force -t ~/.local/share/Trash '
alias untar='tar -zxvf '
alias upgrade='sudo apt -y update && sudo apt -y upgrade ; sudo snap refresh'
alias va='source ./venv/bin/activate'
alias ve='python3 -m venv ./venv'
alias vlc='vlc *.avi'
alias wget='wget -c '
alias wifi='nmcli dev wifi'
alias x_drv='cat ~/.local/share/xorg/Xorg.0.log | grep drivers'
alias x_gpu='cat ~/.local/share/xorg/Xorg.0.log | grep mem'
alias x_input='cat ~/.local/share/xorg/Xorg.0.log | grep libinput'
alias show_json='~/.local/bin/show_json'
alias apt_search='dpkg -S'
alias lsof_reg="lsof | grep REG | awk '{print $NF}' | sort -u"

#alias nplaywave='for i in /nas/multimedia/wave/*.wav; do mplayer "$i"; done'
#alias nplayogg='for i in /nas/multimedia/ogg/*.ogg; do mplayer "$i"; done'
#alias nplaymp3='for i in /nas/multimedia/mp3/*.mp3; do mplayer "$i"; done'

# Reboot my home Linksys WAG160N / WAG54 / WAG320 / WAG120N Router / Gateway from *nix.
#alias rebootlinksys="curl -u 'admin:my-super-password' 'http://192.168.1.1/setup.cgi?todo=reboot'"
 
# Reboot tomato based Asus NT16 wireless bridge
#alias reboottomato="ssh admin@192.168.1.1 /sbin/reboot"

