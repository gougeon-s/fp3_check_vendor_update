#!/data/data/com.termux/files/usr/bin/sh

## INSTALL DEPENDENCIES
echo "[+] Installing dependencies"
pkg update && pkg upgrade -y
pkg install -y curl jq termux-api

## SETUP CROND AT BOOT
echo "[+] Setting up crond at boot"
mkdir -p /data/data/com.termux/files/home/.termux/boot/
cat > /data/data/com.termux/files/home/.termux/boot/00_crond <<EOF
termux-wake-lock && crond
EOF

## SET CRONTAB
echo "[+] Setting up crontab"
mkdir -p /data/data/com.termux/files/home/.termux/app/
cp check_update.sh /data/data/com.termux/files/home/.termux/app/

crontab -l 2>/dev/null | grep "/data/data/com.termux/files/home/.termux/app/check_update.sh" > /dev/null
if [ $? -ne 0 ]; then
  echo "$(crontab -l 2>/dev/null)\n0 17 * * * /data/data/com.termux/files/home/.termux/app/check_update.sh" | crontab -
else
  echo "[-] check_update.sh is already in crontab"
fi

## START CROND
echo "[+] Starting crond"
termux-wake-lock
ps -C crond >/dev/null
[ $? -ne 0 ] && crond

echo "[+] Done"
