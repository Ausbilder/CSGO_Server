#!/bin/bash
for i in {11..20}
do
   sudo ./server.sh -i $i -r blan -p blan -M 10 -h "CS:GO 5on5 WAR #$i"
	echo "Started CS:GO 5on5 ServerID $i"
done