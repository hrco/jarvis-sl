#!/bin/zsh
# Runs every 4 h (launchd). Moves dialect words from the private inbox into
# narecja.md and opens a draft PR. Never pushes to main.
set -eu
cd ${0:A:h}
[[ -s narecja-inbox.md ]] || exit 0
git switch -q main && git pull -q --ff-only
b=table/$(date +%Y%m%d-%H%M)
git switch -q -c $b
claude -p --model haiku --allowedTools "Read,Edit" "Preberi narecja-inbox.md (zasebno, Valetov govor). Poišči samo narečne ali pogovorne slovenske besede. Za vsako besedo, ki je še ni v tabeli, dodaj eno vrstico v narecja.md (stolpci: narečna beseda, knjižno, pomen EN, narečje/regija, sorodno, vir = jarvis + datum). Ne prepisuj celih stavkov, imen ali osebnih podatkov. Ne spreminjaj drugih datotek. Če ni nič novega, ne spremeni ničesar."
if git diff --quiet narecja.md; then
  git switch -q main && git branch -q -D $b
else
  git add narecja.md
  git commit -q -m "docs: new dialect words $(date +%F)" -m "CC - Claude Haiku 5.5 was here"
  git push -q -u origin $b
  gh pr create --draft --fill
  git switch -q main
fi
: > narecja-inbox.md
