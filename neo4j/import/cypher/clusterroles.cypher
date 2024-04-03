//load clusterroles

CALL apoc.load.json("http://172.26.0.1:8001/apis/rbac.authorization.k8s.io/v1/clusterroles")
YIELD value as clusterrolelist

WITH clusterrolelist
UNWIND clusterrolelist.items AS clusterrole
  MERGE (r:ClusterRole { name: clusterrole.metadata.name,
                         kind: "ClusterRole" 
                       } 
        )

