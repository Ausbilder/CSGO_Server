#!/bin/bash
for i in {21..22}
do
   sudo ./server.sh -i $i -r marodeur -p marodeur -M 24 -h "CS:GO 12on12 Public #$i" -o 0 -y 0
	echo "Started CS:GO 12on12 ServerID $i"
done