#!/bin/bash

echo "Dźwig 2 zaczyna pracę..."
przeniesione=0
dzwig1_pid=$1

# Funkcja do obsługi sygnałów
handle_dzwig1_finished() {
    echo "Dźwig 1 zakończył pracę, dźwig 2 kończy prace."
    exit 0
}

# Podpięcie funkcji do obsługi sygnału
trap handle_dzwig1_finished USR1

while true; do
    # Sprawdzanie, czy są pliki w buforze
    if [ "$(ls -1 Bufor 2>/dev/null | wc -l)" -gt 0 ]; then
        file=$(ls -1 Bufor | head -n 1)
        mv "Bufor/$file" "Miejsce2/$file"
        echo "Dźwig 2 przenosi: $file"
        ((przeniesione++))
        sleep 1  # symulacja czasu przenoszenia
    else
        # Jeśli nie ma plików w buforze, sprawdzamy ponownie
        sleep 1
    done
done

echo "Dźwig 2 zakończył pracę."
exit $przeniesione
