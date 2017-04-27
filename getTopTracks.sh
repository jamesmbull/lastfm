#!/bin/bash
#
# Import txt playlist to whatever
# http://www.playlist-converter.net
#
# Run as getTopTracks.sh artist_list.txt
#
# artist_list.txt should contain one artist
# per line
#

while read artist; do
    # Get REST response
    curl "http://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=${artist}&api_key=[ api key ]&format=xml" -o temptracklist.xml
    
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
    
    # Match artist name on same line with track
    cat sedtracklist.txt | sed 'N;s/\n/ /' >> tracklist.txt

done < $1

sed -i "s/&apos;/\'/g" tracklist.txt

rm temptracklist.xml
rm sedtracklist.txt
