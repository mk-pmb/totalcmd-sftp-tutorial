#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function shotter () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  # local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?
  local TMPFN='tmp.png'
  local SAVE= LINK=
  while sleep 1s; do
    LINK="img-hms-$(date +%H%M%S).png"
    scrot --border --silent --focused -- "$TMPFN" || return $?
    SAVE="img-md5-$(md5sum --binary -- "$TMPFN" | grep -oPe '^\w{8}').png"
    if [ -s "$SAVE" ]; then
      rm -- "$TMPFN"
      #    "‘img-hms-231655.png’ -> ‘img-md5-66aa136e.png’"
      echo "($LINK  ==  $SAVE)"
    else
      mv --no-target-directory -- "$TMPFN" "$SAVE" || return $?
      ln --verbose --no-target-directory --symbolic \
        -- "$SAVE" "$LINK" || return $?
    fi
  done
}





shotter "$@"; exit $?
