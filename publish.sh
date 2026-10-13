#!/data/data/com.termux/files/usr/bin/sh
# Usage: sh publish.sh [path-to-apk]
# Copies the newest APK from Downloads (or the one you name), updates size/date on the page, and uploads.
set -e
cd "$(dirname "$0")"
APK="${1:-$(ls -t "$HOME"/storage/downloads/*.apk 2>/dev/null | head -1)}"
if [ -z "$APK" ] || [ ! -f "$APK" ]; then echo "لم أجد ملف APK في التنزيلات"; exit 1; fi
cp "$APK" risha.apk
BYTES=$(wc -c < risha.apk)
SIZE=$(awk -v b="$BYTES" 'BEGIN{printf "%.1f", b/1048576}')
DATE=$(date +%Y-%m-%d)
sed -i "s|<span id=\"size\">[^<]*</span>|<span id=\"size\">$SIZE</span>|" index.html
sed -i "s|<span id=\"date\">[^<]*</span>|<span id=\"date\">$DATE</span>|" index.html
git add -A
git commit -m "Release $DATE" || echo "لا يوجد تغيير جديد"
git push -u origin main
echo "تم الرفع. الرابط: https://ryan-alsaidani.github.io/risha-app/"
