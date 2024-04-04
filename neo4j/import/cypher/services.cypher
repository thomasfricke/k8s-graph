// load services

CALL apoc.load.json("${API_SERVER}/api/v1/services")
YIELD value as service

UNWIND service.items AS v
  MERGE (s:Service {name: v.metadata.name,
                    namespace: v.metadata.namespace,
                    kind: "Service"
                    } )
  WITH s,v
    UNWIND keys(v.spec.selector) AS key
      MERGE (l:LABELS {key: key,label:v.spec.selector[key] })
      MERGE (s)-[r:SELECTS]-(l);
