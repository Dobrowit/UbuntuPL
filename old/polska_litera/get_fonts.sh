more licencja.txt

while true; do
    read -p "Czy zgadzasz się na postanowienia licencji? " yn
    case $yn in
        [Tt]* ) echo "Zaczynam instalację..." & break;;
        [Nn]* ) exit;;
        * ) echo "Odpowiedz - 'tak' lub 'nie'! ";;
    esac
done

mkdir ~/.fonts

#wget http://www.polskalitera.pl/wp-content/uploads/2016/02/Apolonia-2016-TrueType.zip
#wget http://www.polskalitera.pl/wp-content/uploads/2016/02/Apolonia-2016-OpenType.zip
#wget http://www.polskalitera.pl/wp-content/uploads/2012/07/Apolonia-Nova.zip
#wget http://www.polskalitera.pl/wp-content/uploads/2012/06/Apolonia-Grafia.zip
wget http://www.polskalitera.pl/wp-content/uploads/2016/02/Apolonia-2016-pakiet.zip

wget http://www.polskalitera.pl/wp-content/uploads/2012/07/APOLONIA-500.zip
wget http://www.polskalitera.pl/wp-content/uploads/2014/10/Milenium.zip
wget http://www.polskalitera.pl/wp-content/uploads/2014/10/Milosz.zip
wget http://www.polskalitera.pl/wp-content/uploads/2012/07/Iskra.zip
wget http://www.polskalitera.pl/wp-content/uploads/2018/03/antykwa-taranczewskiego2018.zip
wget http://www.polskalitera.pl/wp-content/uploads/2012/07/Gotika.zip

unzip Apolonia-2016-pakiet.zip -d ~/.fonts/
unzip APOLONIA-500.zip -d ~/.fonts/
unzip Milenium.zip -d ~/.fonts/
unzip Milosz.zip -d ~/.fonts/
unzip Iskra.zip -d ~/.fonts/
unzip antykwa-taranczewskiego2018.zip -d ~/.fonts/
unzip Gotika.zip -d ~/.fonts/

rm Apolonia-2016-pakiet.zip APOLONIA-500.zip Milenium.zip Milosz.zip Iskra.zip antykwa-taranczewskiego2018.zip Gotika.zip

# Usuwanie zbędnych czcionek i dodawanie kilku polskich czcionek z repozytorium
sudo apt -y purge fonts-samyak-* fonts-sil-* fonts-smc-* fonts-tlwg-* fonts-lohit-* fonts-kacst* fonts-gubbi fonts-kalapi fonts-teluguvijayam fonts-telu-extra fonts-sarai fonts-sahadeva fonts-pagul fonts-orya-extra fonts-noto-cjk fonts-nakula fonts-lklug-sinhala fonts-lao fonts-khmeros-core fonts-guru-extra fonts-gujr-extra fonts-gargi fonts-deva-extra fonts-beng-extra fonts-tibetan-machine

sudo apt -y autopurge

sudo apt -y install fonts-mononoki fonts-dejavu-extra fonts-babelstone-modern fonts-bajaderka fonts-hack xfonts-mona fonts-3270 fonts-lato

