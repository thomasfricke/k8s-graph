//load serviceaccounts

CALL apoc.load.json("http://172.26.0.1:8001/api/v1/serviceaccounts")
YIELD value as serviceaccount

WITH serviceaccount
UNWIND serviceaccount.items AS v
  MERGE (p:ServiceAccount {name: v.metadata.name,
                namespace: v.metadata.namespace, 
                kind: "ServiceAccount" } )
  WITH p, v
    UNWIND keys(v.metadata.labels) AS key
      MERGE (l:LABELS {key: key,label:v.metadata.labels[key] })
      MERGE (l)-[r:LABELS]-(p)

