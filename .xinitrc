#!/bin/sh
xset -dpms
xset s off
xset s noblank

# Hide X cursor.
unclutter &

chromium-browser --no-sandbox --window-size=480,480 --start-fullscreen --kiosk --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI https://news.ycombinator.com
