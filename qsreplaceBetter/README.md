chmod +x qsreplaceBetter

cat allUrls.txt | grep "=" | grep -v "==" | qsreplaceBetter | httpx 
