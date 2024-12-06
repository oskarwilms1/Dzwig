#!/bin/bash

# Inicjalizacja zmiennych
dzwig1_pid=0
dzwig2_pid=0
ilosc_przeniesionych_1=0
ilosc_przeniesionych_2=0

# Funkcje na sygnały
handle_usr1() {
    echo "Zaczynam pracę dźwigów..."

    # Usunięcie pliku finalizacji dźwigu 1, jeśli istnieje
    rm -f "dzwig1_finished"

    # Uruchomienie dźwigów w tle
    ./dzwig1.sh &
    dzwig1_pid=$!
    ./dzwig2.sh "$dzwig1_pid" &
    dzwig2_pid=$!

    echo "Dźwigi uruchomione: PID1=$dzwig1_pid PID2=$dzwig2_pid"
}

handle_sigint() {
    echo "Otrzymano sygnał SIGINT, kończenie pracy..."

    # Zatrzymanie dźwigów
    kill $dzwig1_pid
    kill $dzwig2_pid

    # Wyświetlenie rezultatów
    wait $dzwig1_pid
    ilosc_przeniesionych_1=$?
    wait $dzwig2_pid
    ilosc_przeniesionych_2=$?

    echo "Dźwig 1 przeniósł $ilosc_przeniesionych_1 materiałów."
    echo "Dźwig 2 przeniósł $ilosc_przeniesionych_2 materiałów."
    
    exit 0
}

# Podpięcie obsługi sygnałów
trap handle_usr1 USR1
trap handle_sigint SIGINT

echo "Nadzorca uruchomiony. Czekam na sygnał..."

# W nieskończonej pętli
while true; do
    sleep 1
    # Sprawdzamy, czy dźwig 1 zakończył pracę
    if ! ps -p "$dzwig1_pid" > /dev/null 2>&1; then
        touch "dzwig1_finished"
        echo "Dźwig 1 zakończył pracę. Informuję dźwig 2."
        kill -USR1 "$dzwig2_pid"  # Informowanie dźwigu 2
    fi
done
