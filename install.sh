#!/data/data/com.termux/files/usr/bin/bash

# Inspired by Khansaad1275 made by funnut
# https://github.com/funnut/yt-pobieracz

TERMUX_HOME="/data/data/com.termux/files/home"
OUTPUT_PATH="${TERMUX_HOME}/storage/downloads/yt-pobieracz"

# Aktualizacja pakietów.
echo "Pobieranie listy pakietów i ich aktualizacja..."
apt-get update && apt-get upgrade -y
if [ $? -ne 0 ]; then
  echo "Błąd podczas aktualizacji pakietów. Przerwano."
  exit 1
fi

# Jeżeli folder storage/ nie istnieje - uruchom termux-setup-storage.
if [ ! -d "${TERMUX_HOME}/storage" ]; then
  echo "Zgoda na dostęp do storage..."
  sleep 2
  termux-setup-storage
  if [ $? -ne 0 ]; then
    echo "Błąd przy ustawianiu dostępu do storage."
    exit 1
  fi
fi

# Instalacja języka Python, jeżeli nie jest zainstalowany.
if ! apt-cache pkgnames | grep "^python$" &>/dev/null; then
  echo "Instalowanie Python..."
  sleep 2
  apt-get install python -y
  if [ $? -ne 0 ]; then
    echo "Błąd podczas instalacji Python."
    exit 1
  fi
fi

# Instalacja termux-api, jeżeli nie jest zainstalowane.
if ! command -v termux-battery-status &> /dev/null; then
  echo "Instalowanie Termux API..."
  pkg install -y termux-api
  if [ $? -ne 0 ]; then
    echo "Błąd podczas instalacji Termux API."
    exit 1
  fi
fi

# Instalowanie yt-dlp, jeżeli nie jest zainstalowane.
if ! pip list | grep "^yt-dlp" &>/dev/null; then
  echo "Instalowanie yt-dlp..."
  sleep 2
  pip install yt-dlp
  if [ $? -ne 0 ]; then
    echo "Błąd podczas instalacji yt-dlp."
    exit 1
  fi
fi

# Tworzenie folderu dla pobieranych plików.
if [ ! -d "${OUTPUT_PATH}" ]; then
  echo "Tworzenie folderu \"${OUTPUT_PATH}\"..."
  sleep 2
  mkdir -p "${OUTPUT_PATH}"
  if [ $? -ne 0 ]; then
    echo "Błąd podczas tworzenia folderu."
    exit 1
  fi
fi

# Instalacja yt-pobieracz.
echo "Instalowanie yt-pobieracz..."
sleep 2
mkdir -p "${TERMUX_HOME}/bin"
cp -f yt-pobieracz "${TERMUX_HOME}/bin/termux-url-opener"
chmod +x "${TERMUX_HOME}/bin/termux-url-opener"
if [ $? -ne 0 ]; then
  echo "Błąd podczas instalacji yt-pobieracz."
  exit 1
fi

echo -e "\nInstalacja zakończona.\n"
echo -e "Udostępnij za pomocą Termux lub uruchom: bash ~/bin/termux-url-opener \"www.linkdowideo.pl\"\n"
echo -e "UWAGA: Pobrane pliki mogą nie być widoczne w galerii.\n"
echo -e "Jeżeli chcesz by były one widoczne - pobierz aplikację Termux:API."
