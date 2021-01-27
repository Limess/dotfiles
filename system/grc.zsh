# GRC colorizes nifty unix tools all over the place
# disabled as it causes autocomplete to not work with make
if (( $+commands[grc] )) && (( $+commands[brew] ))
then
  source `brew --prefix`/etc/grc.bashrc
fi
