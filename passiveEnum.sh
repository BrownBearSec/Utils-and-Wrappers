while getopts d:f: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
        f) filename=${OPTARG};;
    esac
done

if [ ${#domain} -gt 0 ] && [ ${#filename} -gt 0 ] 
then
    echo "Cannot have the domain set, and a domain file set"
    exit
fi

if [ ${#domain} -gt 0 ] 
then    
    crtsh.py $domain
    curl -s "https://subbuster.cyberxplore.com/api/find?domain=$domain" -s | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+"
    curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u
    curl -s "https://certspotter.com/api/v1/issuances?domain=$domain\&include_subdomains=true\&expand=dns_names" |  jq -Mr '.[].dns_names | .[]' | sort -u
    curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname'
    curl -s "https://api.hackertarget.com/hostsearch/?q=$domain" | cut -d, -f1
    curl -s "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//"
    curl -s "https://api.threatminer.org/v2/domain.php?q=$domain&rt=5" | jq -Mr '.results | .[]'
    curl -s "https://threatcrowd.org/searchApi/v2/domain/report/?domain=$domain" | jq -Mr '.subdomains | .[]'
    curl -s "https://urlscan.io/api/v1/search/?q=$domain" | jq -Mr '.results | .[] | .task.domain' | grep "$domain"
    curl -s "https://sonar.omnisint.io/subdomains/$domain" | jq -Mr .[]
fi

if [ ${#filename} -gt 0 ]
then
    while read root; do
        echo "$domain"
        crtsh.py $domain
        curl -s "https://crt.sh/?q=%.$domain\&output=json" | jq -Mr '.[] | .name_value'
        #curl -s "https://subbuster.cyberxplore.com/api/find?domain=$domain" -s | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+"
        curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u
        #curl -s "https://certspotter.com/api/v1/issuances?domain=$domain\&include_subdomains=true\&expand=dns_names" |  jq -Mr '.[].dns_names | .[]' | sort -u
        curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname'
        #curl -s "https://api.hackertarget.com/hostsearch/?q=$domain" | cut -d, -f1
        curl -s "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//"
        curl -s "https://api.threatminer.org/v2/domain.php?q=$domain&rt=5" | jq -Mr '.results | .[]'
        curl -s "https://threatcrowd.org/searchApi/v2/domain/report/?domain=$domain" | jq -Mr '.subdomains | .[]'
        curl -s "https://urlscan.io/api/v1/search/?q=$domain" | jq -Mr '.results | .[] | .task.domain' | grep "$domain"
        curl -s "https://sonar.omnisint.io/subdomains/$domain" | jq -Mr .[]
    done <$filename
fi

: <<'END_COMMENT
crtsh.py $domain | anew allSubs.txt
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | anew allSubs.txt 
curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname' | anew allSubs.txt 
curl -s "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//" | grep -v "<" | anew allSubs.txt
curl -s "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//" | grep -v "<" | anew allSubs.txt
curl -s "https://urlscan.io/api/v1/search/?q=$domain" | jq -Mr '.results | .[] | .task.domain' | grep "$domain" | anew allSubs.txt
curl -s "https://sonar.omnisint.io/subdomains/$domain" | jq -Mr .[] | grep -v "no results found" | anew allSubs.txt
#API NEEDED/LIMITED/SLOW
curl -s "https://subbuster.cyberxplore.com/api/find?domain=$domain" -s | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | anew allSubs.txt
curl -s "https://certspotter.com/api/v1/issuances?domain=$domain&include_subdomains=true&expand=dns_names" |  jq -Mr '.[].dns_names | .[]' | sort -u | grep -v "\*" | anew allSubs.txt
curl -s "https://api.hackertarget.com/hostsearch/?q=$domain" | cut -d, -f1 | anew allSubs.txt
curl -s "https://api.threatminer.org/v2/domain.php?q=$domain&rt=5" | jq -Mr '.results | .[]' | anew allSubs.txt 


END_COMMENT

while read domain; do crtsh.py $domain | anew allSubs.txt; done <rootdomains.txt
while read domain; do curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | anew allSubs.txt ; done <rootdomains.txt
while read domain; do curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname' | anew allSubs.txt ; done <rootdomains.txt
while read domain; do curl -s "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//" | anew allSubs.txt; done <rootdomains.txt
while read domain; do curl -s "https://threatcrowd.org/searchApi/v2/domain/report/?domain=$domain" | jq -Mr '.subdomains | .[]' | anew allSubs.txt; done <rootdomains.txt
while read domain; do curl -s "https://urlscan.io/api/v1/search/?q=$domain" | jq -Mr '.results | .[] | .task.domain' | grep "$domain" | anew allSubs.txt; done <rootdomains.txt
while read domain; do curl -s "https://sonar.omnisint.io/subdomains/$domain" | jq -Mr .[] | grep -v "no results found" | anew allSubs.txt; done <rootdomains.txt
