SOURCE="~/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
LINK="/usr/local/bin/sublime"

if [ -f "$SOURCE" ] && [ ! -L "$LINK" ]; then
    sudo ln -sf "$SOURCE" $LINK
fi
