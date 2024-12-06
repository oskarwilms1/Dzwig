#!/bin/bash


echo "Dźwig 1 zaczyna pracę..."
przeniesione=0

while [ "$(ls -1 Miejsce1 | wc -l)" -gt 0 ]; do
    if [ "$(ls -1 Bufor | wc -l)" -lt 3 ]; then
        file=$(ls -1 Miejsce1 | head -n 1)
        mv "Miejsce1/$file" "Bufor/$file"
        echo "Dźwig 1 przenosi: $file"
        ((przeniesione++))
    fi
    sleep 1  # symulacja czasu przenoszenia
done

echo "Dźwig 1 zakończył pracę."
exit $przeniesione