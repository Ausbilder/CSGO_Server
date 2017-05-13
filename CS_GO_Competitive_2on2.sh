#!/bin/bash
for i in {1..10}
do
   sudo ./server.sh -i $i -r blan -p blan -M 6 -h "CS:GO 2on2 WAR #$i"
	echo "Started CS:GO 3on3 ServerID $i"
done