#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function imglist () {
  local DN="$(basename -- "$PWD")"
  [ "$DN" == / ] && DN='root'
  local DEST="imglist.$DN.$$.html"
  sed -nre 's~^ {2}~~;/\S/p' <<<'
    <!DOCTYPE html><html><head><meta charset="UTF-8">
    <title>'"${DN//[<>&]/?}"'</title>
    <style type="text/css">
      html, body { margin: 2px; padding: 0; }
      body { background-color: white; }
      a { text-decoration: none; margin-top: 2px; }
      img { border-width: 0; }
    </style>
    <style type="text/css">@import url("imglist.custom.css");</style>
    '
  echo '</head><body>'
  local IMG= TPL='  <a id="%" name="%" href="#%"><img src="%" alt="%"></a>'
  for IMG in *.png *.jpeg; do
    [ -s "$IMG" ] || continue
    echo "${TPL//%/$IMG}"
  done
  echo '</body></html>'
}

imglist "$@"; exit $?
