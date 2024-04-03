//load pods

CALL apoc.load.json("http://172.26.0.1:8001/api/v1/pods")
YIELD value as pod

WITH pod
UNWIND pod.items AS v
  MERGE (p:Pod {name: v.metadata.name,
                namespace: v.metadata.namespace, 
                kind: "Pod"
         } )
  WITH p,v
  MATCH (s:ServiceAccount{
           name: coalesce( v.spec.serviceAccountName, "default" ),
           namespace:  v.metadata.namespace,
           kind: "ServiceAccount"
          } )
  WITH s, p,v
  MERGE (p)-[rs:CREATED_BY]->(s) 

  WITH p, v
    UNWIND keys(v.metadata.labels) AS key
      MERGE (l:LABELS {key: key,label:v.metadata.labels[key] })
      MERGE (l)-[r:LABELS]-(p)
    WITH v.spec.containers as containers, p as p
      UNWIND containers as cv
        MERGE (c:Containers {name: cv.name, image: cv.image })
        MERGE (p)-[rc:CONTAINS]-(c)

