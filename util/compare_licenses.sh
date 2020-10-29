#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function compare_licenses () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  local LICS=()
  readarray -t LICS < <(sed -nrf <(echo '
    /^Copyright \([Cc]\) /{
      : collect
        N
      /SUCH DAMAGE/!b collect
      s~\n~¶~g
      p
    }') -- ../LICENSE.md)

  local BSD_LIC="${LICS[0]//¶/$'\n'}"
  local WFX_LIC="${LICS[1]//¶/$'\n'}"

  local DIFF_OPT=(
    --start-delete=$'\x1b[0;33m[wfx-> ' --end-delete=$' <-wfx]\x1b[0m'
    --start-insert=$'\x1b[0;92m[bsd-> ' --end-insert=$' <-bsd]\x1b[0m'
    # --auto-pager
    )
  wdiff "${DIFF_OPT[@]}" -- <(echo "$WFX_LIC") <(echo "$BSD_LIC")
}










[ "$1" == --lib ] && return 0; compare_licenses "$@"; exit $?
