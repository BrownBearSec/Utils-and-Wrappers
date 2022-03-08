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
    curl -s "https://crt.sh/\\?q\\=\\%.$domain\\&output\\=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
    curl "https://subbuster.cyberxplore.com/api/find?domain=$domain" -s | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+"
    curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u
    curl -s "https://certspotter.com/api/v1/issuances?domain=$domain&include_subdomains=true&expand=dns_names" | jq .[].dns_names | tr -d '[]"\n ' | tr ',' '\n'
    curl "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname'
    curl "https://api.hackertarget.com/hostsearch/?q=$domain" | cut -d, -f1
    curl "https://rapiddns.io/subdomain/$domain" | grep "$domain" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//"
    curl "https://api.threatminer.org/v2/domain.php?q=$domain\&rt=5" | jq -Mr '.results | .[]'
    curl "https://threatcrowd.org/searchApi/v2/domain/report/?domain=$domain" | jq -Mr '.subdomains | .[]'
    curl "https://urlscan.io/api/v1/search/?q=$domain" | jq -Mr '.results | .[] | .task.domain' | grep "$domain"
    curl "https://sonar.omnisint.io/subdomains/$domain" | jq -Mr .[]
fi

if [ ${#filename} -gt 0 ]
then
    while read root; do
        curl -s "https://crt.sh/\\?q\\=\\%.$root\\&output\\=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u
        curl "https://subbuster.cyberxplore.com/api/find?domain=$root" -s | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+"
        curl -s "https://riddler.io/search/exportcsv?q=pld:$root" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u
        curl -s "https://certspotter.com/api/v1/issuances?domain=$root&include_subdomains=true&expand=dns_names" | jq .[].dns_names | tr -d '[]"\n ' | tr ',' '\n'
        curl "https://otx.alienvault.com/api/v1/indicators/domain/$root/passive_dns" | jq -Mr '.passive_dns | .[] | .hostname'
        curl "https://api.hackertarget.com/hostsearch/?q=$root" | cut -d, -f1
        curl "https://rapiddns.io/subdomain/$root" | grep "$root" | grep -v "=\|RapidDNS" | sed -e "s/^<td>//" | sed -e "s/<\/td>//"
        curl "https://api.threatminer.org/v2/domain.php?q=$root\&rt=5" | jq -Mr '.results | .[]'
        curl "https://threatcrowd.org/searchApi/v2/domain/report/?domain=$root" | jq -Mr '.subdomains | .[]'
        curl "https://urlscan.io/api/v1/search/?q=$root" | jq -Mr '.results | .[] | .task.domain' | grep "$root"
        curl "https://sonar.omnisint.io/subdomains/$root" | jq -Mr .[]
    done <$filename
fi