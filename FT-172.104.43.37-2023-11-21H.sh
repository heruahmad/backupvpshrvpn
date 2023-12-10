#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

REPO="https://raw.githubusercontent.com/sasak3/v4/main/"
clear
red='\e[1;31m'
green='\e[1;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
ipsaya=$(curl -sS ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )

#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

mkdir -p /etc/xray
mkdir -p /etc/v2ray
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/scdomain
touch /etc/v2ray/scdomain


echo -e "[ ${tyblue}NOTES${NC} ] Before we go.. "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] I need check your headers first.."
sleep 2
echo -e "[ ${green}INFO${NC} ] Checking headers"
sleep 1
totet=`uname -r`
REQUIRED_PKG="linux-headers-$totet"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  sleep 2
  echo -e "[ ${yell}WARNING${NC} ] Try to install ...."
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  apt-get --yes install $REQUIRED_PKG
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${tyblue}NOTES${NC} ] If error you need.. to do this"
  sleep 1
  echo ""
  sleep 1
  echo -e "[ ${green}NOTES${NC} ] 1. apt update -y"  
  echo -e "[ ${green}NOTES${NC} ] 2. apt upgrade -y"
  echo -e "[ ${green}NOTES${NC} ] 3. apt dist-upgrade -y"
  echo -e "[ ${green}NOTES${NC} ] 4. reboot"
  sleep 2
  echo -e "[ ${green}NOTES${NC} ] After rebooting"
  echo -e "[ ${green}NOTES${NC} ] Then run this script again"
  echo -e "[ ${yell}NOTES${NC} ] Script Mod By HR-vpn"
  echo -e "[ ${red}NOTES${NC} ] if you understand then tap enter"
  read
else
  echo -e "[ ${red}INFO${NC} ] Oke installed"
fi

ttet=`uname -r`
ReqPKG="linux-headers-$ttet"
if ! dpkg -s $ReqPKG  >/dev/null 2>&1; then
  rm /root/setup.sh >/dev/null 2>&1 
  exit
else
  clear
fi


secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Aight good ... installation file is ready"
sleep 2
echo -ne "[ ${green}INFO${NC} ] Check permission : "
data_ip="https://raw.githubusercontent.com/heruahmad1/permission/main/ipmini"
checking_sc() {
    useexp=$(curl -sS $data_ip | grep $ipsaya | awk '{print $3}')
    if [[ $date_list < $useexp ]]; then
        echo -ne
    else
        echo -e "\033[1;36m┌─────────────────────────────────────────────────┐\033[0m"
        echo -e "\033[1;36m \033[0m ${COLBG1}       ${WH}• 404 NOT FOUND AUTOSCRIPT •               \033[0m \033[1;36m $NC"
        echo -e "\033[1;36m└─────────────────────────────────────────────────┘\033[0m"
        echo -e "\033[1;36m┌─────────────────────────────────────────────────┐\033[0m"
        echo -e "            ${RED}PERMISSION DENIED !\033[0m"
        echo -e "   \033[0;33mYour VPS\033[0m $ipsaya \033[0;33mHas been Banned\033[0m"
        echo -e "     \033[0;33mBuy access permissions for scripts\033[0m"
        echo -e "             \033[0;33mContact Your Admin \033[0m"
        echo -e "     \033[0;36mTelegram\033[0m: https://t.me/heruahmad"
        echo -e "\033[1;36m└─────────────────────────────────────────────────┘\033[0m"
        exit
    fi
}
checking_sc
Name=$(curl -sS https://raw.githubusercontent.com/heruahmad1/permission/main/ipmini | grep $ipsaya | awk '{print $2}')
# =========================================
echo -e "[ ${red}INFO${NC} ] Your ip valid registration"
echo -e "[ ${red}INFO${NC} ] Proses install...... "
mkdir -p /var/lib/SIJA >/dev/null 2>&1
echo "IP=" >> /var/lib/SIJA/ipvps.conf

    # > pasang gotop
    gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1

    # > Pasang BBR Plus
    wget -qO /tmp/bbr.sh "${REPO}server/bbr.sh" >/dev/null 2>&1
    chmod +x /tmp/bbr.sh && bash /tmp/bbr.sh

  
echo ""
wget -q https://raw.githubusercontent.com/sasak3/v4/main/dep.sh;chmod +x dep.sh;./dep.sh
rm dep.sh
clear
clear
echo ""
  echo -e "\e[32m      ┌───────────────────────────────────────────────┐\033[0m"
  echo -e "\e[32m   ───│                                               │───\033[0m"
  echo -e "\e[32m   ───│    ┌─┐┬ ┬┌┬┐┌─┐┌─┐┌─┐┬─┐┬┌─┐┌┬┐  ┬  ┬┌┬┐┌─┐   │───\033[0m"
  echo -e "\e[32m   ───│    ├─┤│ │ │ │ │└─┐│  ├┬┘│├─┘ │   │  │ │ ├┤    │───\033[0m"
  echo -e "\e[32m   ───│    ┴ ┴└─┘ ┴ └─┘└─┘└─┘┴└─┴┴   ┴   ┴─┘┴ ┴ └─┘   │───\033[0m"
  echo -e "\e[32m      │\033[0m  \e[33m      HR-vpn (C)https://t.me/HRstores      \033[0m \e[32m │\033[0m"
  echo -e "\e[32m      └───────────────────────────────────────────────┘\033[0m"
    echo -e "${red}                ♦️ CUSTOM SETUP DOMAIN VPS ♦️   ${NC}"
    echo -e "\e[32m      ┌───────────────────────────────────────────────┐\033[0m"
    echo "          1. Gunakan Domain Dari Script"
    echo "          2. Pilih Domain Sendiri"
    echo -e "\e[32m      └───────────────────────────────────────────────┘\033[0m"
    read -rp " Tentukan domain anda : " dom 

if test $dom -eq 1; then
clear
wget -q -O /root/cf.sh "https://raw.githubusercontent.com/sasak3/v4/main/slowdns/cf.sh"
chmod +x /root/cf.sh
./cf.sh
elif test $dom -eq 2; then
read -rp "Domain/Host: " -e host
echo "IP=$host" >> /var/lib/SIJA/ipvps.conf
 "IP=$host" >> /etc/xray/domain

fi
echo -e "${GREEN}Done.${NC}"
sleep 2
clear
echo "IP=$host" >> /var/lib/SIJA/ipvps.conf
#echo "IP=$host" >> /var/lib/scrz-prem/ipvps.conf
echo "$host" >> /root/domain
#clear
wget https://raw.githubusercontent.com/sasak3/v4/main/slowdns/cfslow.sh && chmod +x cfslow.sh && ./cfslow.sh
rm -f /root/cfslow.sh
clear
wget https://raw.githubusercontent.com/sasak3/v4/main/ssh/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
clear
wget https://raw.githubusercontent.com/botak8/v4/main/backup/set-br.sh &&  chmod +x set-br.sh && ./set-br.sh
clear
wget https://raw.githubusercontent.com/sasak3/v4/main/xray/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
wget https://raw.githubusercontent.com/botak8/v4/main/sshws/insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
wget -q -O slow.sh https://raw.githubusercontent.com/Andyyuda/xray-ssh/main/slow.sh && chmod +x slow.sh && ./slow.sh
clear
wget https://raw.githubusercontent.com/sasak3/v4/main/udp/udp.sh && bash udp.sh
clear
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[0;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  \033[0;33mPlease Wait Loading \033[1;37m- \033[0;33m["
    done
    echo -e "\033[0;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}
res1() {
wget -q https://raw.githubusercontent.com/botak8/v4/main/xray/f.sh;chmod +x f.sh;./f.sh
rm f.sh
}
netfilter-persistent
clear
fun_bar 'res1'
clear

cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
rm /root/setup.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
echo -ne "[ ${yell}WARNING${NC} ] proses install selesai..."
echo -e "
"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
