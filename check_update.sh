#!/data/data/com.termux/files/usr/bin/sh

URL="https://support.fairphone.com/hc/en-us/articles/360035486772-Update-your-Fairphone-3-to-the-latest-software"
FORUM_URL="https://forum.fairphone.com/t/twrp-installable-stock-firmware-packages-for-fairphone-3/57219"

CURRENT_VERSION=$(getprop ro.product.build.fingerprint | sed 's/.*\.A\.//g' | sed 's/\..*//g')
LAST_VERSION=$(curl -s $URL | grep "<strong>OS version" | sed 's/.*OS version //g' | sed 's/<.*//g')

[ -z "$LAST_VERSION" ] && exit 0 # Couldn't get the last version, abort

[ "$CURRENT_VERSION" = "$LAST_VERSION" ] && exit 0 # Up to date

dialog_4_url="termux-dialog confirm \\
      -t \"FP3 Vendor Update\" \\
      -i \"Your current version is A.${CURRENT_VERSION}.
The new version is A.${LAST_VERSION}.

Do you want to look at the forum if a flashable zip is available ?\" "

ask_open_url="[ \"\$( ${dialog_4_url} | jq -r .text )\" = \"yes\" ] && termux-open-url \"${FORUM_URL}\" "

termux-notification \
    --title "FP3 Vendor Update" \
    -c "A new vendor update is available : A.${LAST_VERSION}" \
    --action "${ask_open_url}" \
