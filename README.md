# Readme

This is an example proof of concept to map Kubernetes objects to a Graph DB.
The example Helm charts downloads the Neo4J database and installs the 
`apoc.jar` plugin, which must be placed in the `neo4j/plugins` folder.

The `./neo4j/import/cypher` contains the cypher scripts, which are absorbed
into a config map and executed sequentially.
