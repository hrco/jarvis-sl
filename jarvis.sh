#!/bin/zsh
# Jarvis: you speak, whisper hears, Claude answers, Tina speaks. Ctrl-C stops.
# Raw speech goes to narecja-inbox.md (private, gitignored). update.sh moves
# only the dialect words into narecja.md (public).
set -u
DIR=${0:A:h}
MODEL=${WHISPER_MODEL:-$HOME/models/ggml-base.bin}
MIC=${MIC:-2}    # 2 = MacBook Air Microphone (ffmpeg avfoundation index)
SECS=${SECS:-8}  # seconds per turn
TMP=$(mktemp -d)

[[ -f $MODEL ]] || { print "Ni modela: $MODEL"; exit 1; }

while true; do
  say -v Tina "Poslušam."
  ffmpeg -hide_banner -loglevel error -y -f avfoundation -i ":$MIC" -t $SECS -ar 16000 -ac 1 $TMP/in.wav
  text=$(whisper-cli -m $MODEL -l sl -nt -np -f $TMP/in.wav | tr -s ' \n' ' ')
  [[ -z ${text// } ]] && continue
  print "Ti: $text"
  print -r -- "- $(date '+%F %H:%M') $text" >> $DIR/narecja-inbox.md
  # run from an empty dir so Claude talks to Vale, not about the repo
  answer=$(cd $TMP && claude -p --model haiku "Si Jarvis, Valetov pomočnik. Odgovori kratko, po slovensko, največ dva stavka. Vale reče: $text")
  print "Jarvis: $answer"
  say -v Tina "$answer"
done
