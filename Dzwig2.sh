#!/bin/bash


echo "Dźwig 2 zaczyna pracę..."
przeniesione=0

while true; do
    if [ "$(ls -1 Bufor | wc -l)" -gt 0 ]; then
        file=$(ls -1 Bufor | head -n 1)
        mv "Bufor/$file" "Miejsce2/$file"
        echo "Dźwig 2 przenosi: $file"
        ((przeniesione++))
        sleep 1  # symulacja czasu przenoszenia
    else
        # Zakończ operacje, jeśli dźwig 1 skończył i bufor jest pusty
        if ! ps -p "$dzwig1_pid" > /dev/null; then
            break
        fi
    fi
done

echo "Dźwig 2 zakończył pracę."
exit $przeniesione