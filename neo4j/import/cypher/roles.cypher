//load roles

CALL apoc.load.json("http://172.26.0.1:8001/apis/rbac.authorization.k8s.io/v1/roles")
YIELD value as rolelist

WITH rolelist
UNWIND rolelist.items AS role
  MERGE (r:Role {name: role.metadata.name,
                namespace: role.metadata.namespace, 
                kind: "Role" } )

