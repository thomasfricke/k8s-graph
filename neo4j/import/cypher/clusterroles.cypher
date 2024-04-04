//load clusterroles

CALL apoc.load.json("${API_SERVER}/apis/rbac.authorization.k8s.io/v1/clusterroles")
YIELD value as clusterrolelist

WITH clusterrolelist
UNWIND clusterrolelist.items AS clusterrole
  MERGE (r:ClusterRole { name: clusterrole.metadata.name,
                         kind: "ClusterRole" 
                       } 
        )

