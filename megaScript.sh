export domain="$1"
echo "getting subs for $domain"
echo "$domain" | anew tempSubs.txt

crtsh.py $domain | anew -q tempSubs.txt
sleep 5
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | anew -q tempSubs.txt 
sleep 5
curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname' | anew -q tempSubs.txt 
sleep 5
curl -s "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//" | grep -v "<" | anew -q tempSubs.txt
sleep 5
curl -s "https://urlscan.io/api/v1/search/?q=$domain" | jq -Mr '.results | .[] | .task.domain' | grep "$domain" | anew -q tempSubs.txt
sleep 5
curl -s "https://sonar.omnisint.io/subdomains/$domain" | jq -Mr .[] | grep -v "no results found" | anew -q tempSubs.txt
sleep 5
curl -s "https://subbuster.cyberxplore.com/api/find?domain=$domain" -s | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | anew -q tempSubs.txt
sleep 5
curl -s "https://certspotter.com/api/v1/issuances?domain=$domain&include_subdomains=true&expand=dns_names" |  jq -Mr '.[].dns_names | .[]' | sort -u | grep -v "\*" | anew -q tempSubs.txt
sleep 5
curl -s "https://api.hackertarget.com/hostsearch/?q=$domain" | cut -d, -f1 | anew -q tempSubs.txt
sleep 5
curl -s "https://api.threatminer.org/v2/domain.php?q=$domain&rt=5" | jq -Mr '.results | .[]' | anew -q tempSubs.txt 
sleep 5
github-subdomains -t /home/joe/bugbounty/generalResources/githubKeys.txt -d $domain -raw | anew -q tempSubs.txt
sleep 5
assetfinder --subs-only $domain | anew -q tempSubs.txt
sleep 5
findomain -t $domain -q | anew -q tempSubs.txt
sleep 5
subfinder -d $domain -silent | anew -q tempSubs.txt
sleep 5
gobuster dns -d $domain -w ~/bugbounty/generalResources/subdomains-top1million-20000.txt | grep "Found" | awk '{ print $NF }' | anew -q tempSubs.txt
sleep 5

#cat openRedirect.txt | grep "justeat" | qsreplaceBetter http://www.bugcrowd.com/ | uro | awk '{ print $1 }' | httpx -fr -sc -title -silent
#MAKE SURE TO DO FILTER FOR ORIGINAL DOMAIN HERE
cat tempSubs.txt | grep "$domain" | grep -v "@" > a.txt
mv a.txt tempSubs.txt


# echo "doing urls for $domain"

cat tempSubs.txt | httpx | sed 's/https\?:\/\///' | anew -q tempLive.txt
# sleep 5
# echo "doing gau"
# cat tempLive.txt | gauplus |grep "=" | grep -v "==" | uro | anew -q tempParams.txt
# sleep 5
# echo "doing waybackurls"
# cat tempLive.txt | waybackurls | grep "=" | grep -v "==" | uro | anew -q tempParams.txt
# echo "done waybackurls"
# sleep 5
# cat tempParams.txt | qsreplace AAAAA | xssXD -c 20 | anew xss.txt
# sleep 5
# cat tempParams.txt | grep "=http" | qsreplaceBetter http://bugcrowd.com/ | httpx -fr -nc -sc -title | grep "\[https://www\.bugcrowd" | anew openRedirect.txt
# sleep 5
# /opt/GitTools/Finder/gitfinder.py -i tempLive.txt | anew -q tempGit.txt
# sleep 5
# nuclei -l tempLive -t /home/joe/nuclei-templates/exposures/backups/zip-backup-files.yaml -o tempZips.txt -ni;
# sleep 5

# echo "cleaning files for $domain"

# cat tempLive.txt |  anew -q allLive.txt
# rm tempLive.txt
# cat tempGit.txt | anew -q allGit.txt
# rm tempGit.txt
# cat tempZips.txt | anew -q allZips.txt
# rm tempZips.txt

rm tempSubs.txt
rm $domain.txt
# #rm tempParams.txt