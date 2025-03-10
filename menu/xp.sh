#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
echo 1 > /proc/sys/vm/drop_caches
data=( `cat /etc/xray/ssh | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);
now=$(date +"%Y%m%d%H%M")
for user in "${data[@]}"
do
pass=$(grep -w "^### $user" "/etc/xray/ssh" | cut -d ' ' -f 4 | sort | uniq)
exp=$(grep -w "^### $user" "/etc/xray/ssh" | cut -d ' ' -f 3 | sort | uniq)
exp1=$(grep -w "^### $user" "/etc/xray/ssh" | cut -d ' ' -f 5 | sort | uniq)
exp2=$((exp1 - now ))
if [[ "$exp2" -le "0" ]]; then
  # Check if the user exists
  if getent passwd $user > /dev/null 2>&1; then
    # Log the username and password before modifying the username
    awk -v user="$user" '$2 == user {print $2 " " $4}' /etc/xray/ssh >> /etc/xray/expired
    passwd -l  $user
  else
    # If the user doesn't exist, remove their entry from /etc/xray/ssh and /etc/xray/expired
    sed -i "/^### $user /d" /etc/xray/ssh
    sed -i "/^$user /d" /etc/xray/expired
  fi

  # No file removal
fi
systemctl restart ws-stunnel
done
data=( `cat /etc/xray/config.json | grep '^#vmg' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#vmg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -w "^#vmg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
if [ ! -e /etc/vmess/akundelete ]; then
echo "" > /etc/vmess/akundelete
fi
clear
echo "### $user $exp $uuid" >> /etc/vmess/akundelete
sed -i "/^#vmg $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vm $user $exp/,/^},{/d" /etc/xray/config.json
rm -f /etc/xray/$user-tls.json /etc/xray/$user-none.json
rm /home/vps/public_html/vmess-$user.txt >/dev/null 2>&1
rm /etc/vmess/${user}IP >/dev/null 2>&1
rm /etc/vmess/${user}login >/dev/null 2>&1
fi
done
data=( `cat /etc/xray/config.json | grep '^#vlg' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -w "^#vlg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
if [ ! -e /etc/vless/akundelete ]; then
echo "" > /etc/vless/akundelete
fi
clear
echo "### $user $exp $uuid" >> /etc/vless/akundelete
sed -i "/^#vlg $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#vl $user $exp/,/^},{/d" /etc/xray/config.json
rm /home/vps/public_html/vless-$user.txt >/dev/null 2>&1
rm /etc/vless/${user}IP >/dev/null 2>&1
rm /etc/vless/${user}login >/dev/null 2>&1
fi
done
data=( `cat /etc/xray/config.json | grep '^#trg' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
uuid=$(grep -w "^#trg $user" "/etc/xray/config.json" | cut -d ' ' -f 4 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
if [ ! -e /etc/trojan/akundelete ]; then
echo "" > /etc/trojan/akundelete
fi
clear
echo "### $user $exp $uuid" >> /etc/trojan/akundelete
sed -i "/^#tr $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#trg $user $exp/,/^},{/d" /etc/xray/config.json
rm /home/vps/public_html/trojan-$user.txt >/dev/null 2>&1
rm /etc/trojan/${user}IP >/dev/null 2>&1
rm /etc/trojan/${user}login >/dev/null 2>&1
fi
done
systemctl restart xray
data=( `cat /etc/xray/config.json | grep '^#ssg' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#ssg $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^#ssg $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#ssg $user $exp/,/^},{/d" /etc/xray/config.json
fi
done
systemctl restart xray
data=( `cat /etc/xray/config.json | grep '^#ss' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#ss $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^#ss $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^#ss $user $exp/,/^},{/d" /etc/xray/config.json
fi
done
systemctl restart xray
hariini=`date +%d-%m-%Y`
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
do
tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
username=`echo $tuserval | cut -f1 -d:`
userexp=`echo $tuserval | cut -f2 -d:`
userexpireinseconds=$(( $userexp * 86400 ))
tglexp=`date -d @$userexpireinseconds`
tgl=`echo $tglexp |awk -F" " '{print $3}'`
while [ ${#tgl} -lt 2 ]
do
tgl="0"$tgl
done
while [ ${#username} -lt 15 ]
do
username=$username" "
done
bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
todaystime=`date +%s`
if [ $userexpireinseconds -ge $todaystime ] ;
then
:
else
passwd -l $username
fi
done
systemctl reload ssh

clear 
#read -n 1 -s -r -p "Press any key to back on menu"
