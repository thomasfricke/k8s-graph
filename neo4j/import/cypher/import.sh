#!/bin/bash

cd $(dirname $0)

for i in erase serviceaccounts  pods services create-cve \
	 roles clusterroles clusterrolebindings rolebindings
do  
	echo -n importing $i ...
        
	while ! $(sed 's+\${API_SERVER}+'$API_SERVER+ ${i}.cypher \
		| cypher-shell -a "${NEO4J_ADDRESS}" -u "${NEO4J_USERNAME}" -p "${NEO4J_PASSWORD}" ) 
        do 
	  echo -n .
	done
	echo done
done

