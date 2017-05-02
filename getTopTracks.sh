#!/bin/bash
#
# Import txt playlist to whatever
# http://www.playlist-converter.net
#
# Run as getTopTracks.sh 10 artist_list.txt
#
# The number is the limit on songs returned
#
# artist_list.txt should contain one artist
# per line
#

while read artist; do
    # Get REST response
    # http://www.last.fm/api
    curl "http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&autocorrect=1&limit=${1}&artist=${artist}&api_key=[ YOUR KEY HERE ]&format=xml" > temptracklist.xml
    
    #Parse XML
    read_dom () {
        local IFS=\>
	read -d \< ENTITY CONTENT
    } 

    while read_dom; do
        if [[ $ENTITY = "name" ]]; then
            echo $CONTENT >> sedtracklist.txt
        fi
    done < temptracklist.xml
    
done < $2

# Match artist name on same line with track
cat sedtracklist.txt | sed 'N;s/\n/ /' >> tracklist.txt

sed -i "s/&apos;/\'/g" tracklist.txt
sed -i "s/&amp;/\&/g" tracklist.txt

rm temptracklist.xml
rm sedtracklist.txt
