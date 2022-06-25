chmod +x qsreplaceBetter

sudo cp ./qsreplaceBetter /usr/bin/


cat allUrls.txt | grep "=" | grep -v "==" | qsreplaceBetter | httpx 
