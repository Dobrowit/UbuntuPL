#!/bin/bash

# Przygotowanie pliku z nazwami pakietów
cat pkg/apt-install.txt | grep -v '^#' | grep -v -e '^$' | sort > pakiety.txt

# Ścieżka do pliku z nazwami pakietów
input_file="pakiety.txt"

# Plik wyjściowy
output_file="pakiety_z_opisami.txt"

# Tworzymy lub czyścimy plik wyjściowy
> "$output_file"

# Pętla po każdym pakiecie z pliku
while read -r package; do
  # Pobieramy sekcję pakietu (dział)
  section=$(apt show "$package" 2>/dev/null | awk -F ': ' '/^Section:/ {print $2}')
  
  # Usuwamy część przed ukośnikiem i ukośnik
  section=$(echo "$section" | sed 's/^[^/]*\///')

  # Pobieramy opis pakietu
  #description=$(apt -a show "$package" 2>/dev/null | awk '/^Description:/,/^$/ {if($1!="Description:") print}' | tr -d '\n')
  description=$(apt -a show "$package" 2>/dev/null | awk -F ': ' '/^Description:/ {print substr($2, 1, length($2))}' | awk 'NR==1 {print}' | sed 's/^ *//')

  # Sprawdzamy, czy znaleziono opis
  if [[ -n "$description" ]]; then
    # Usuwamy znaki cudzysłowu
    description=$(echo "$description" | sed 's/"//g')

    # Usuwamy nadmiarowe spacje i podwójne spacje
    description=$(echo "$description" | sed 's/^ *//;s/  */ /g')
    
    # Usuwamy kropki z poprzedzającą spacją
    description=$(echo "$description" | sed 's/ \././g')
    
    # Sprawdzamy długość opisu
    if [[ ${#description} -gt 120 ]]; then
      # Jeśli opis jest dłuższy niż 120 znaków, przycinamy go i dodajemy trzy kropki
      short_description=$(echo "$description" | cut -c1-117)"..."
    else
      # Jeśli opis jest krótszy lub równy 120 znaków, zostawiamy go bez zmian
      short_description="$description"
    fi
  else
    # Jeśli brak opisu, ustawiamy tekst zastępczy
    short_description="Brak opisu"
  fi

  # Zapisujemy nazwę pakietu, dział oraz opis do pliku wyjściowego
  #echo "\"[$section]\" \"$package\" \"$short_description\"" >> "$output_file"
  echo "true" >> "$output_file"
  echo "$section" >> "$output_file"
  echo "$packagen" >> "$output_file"
  echo "$short_description" >> "$output_file"
  echo "[$section] $package - $short_description"

done < "$input_file"

sort "$output_file" > "${output_file}.tmp"
mv "${output_file}.tmp" "$output_file"

echo -e "\nOpisy pakietów zostały zapisane w $output_file."

cat $output_file | \
yad --title="Lista pakietów" \
    --list \
    --grid-lines=vert \
    --checklist \
    --column="Sel" \
    --column="Klasa" \
    --column="Nazwa pakietu" \
    --column="Opis"
