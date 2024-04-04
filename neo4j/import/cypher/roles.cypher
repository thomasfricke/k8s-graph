//load roles

CALL apoc.load.json("${API_SERVER}/apis/rbac.authorization.k8s.io/v1/roles")
YIELD value as rolelist

WITH rolelist
UNWIND rolelist.items AS role
  MERGE (r:Role {name: role.metadata.name,
                namespace: role.metadata.namespace, 
                kind: "Role" } )

