//load rolebindingss

CALL apoc.load.json("${API_SERVER}/apis/rbac.authorization.k8s.io/v1/rolebindings")
YIELD value as rolebindinglist

WITH rolebindinglist
UNWIND rolebindinglist.items AS rolebinding
  MERGE (rb:RoleBinding {name: rolebinding.metadata.name,
                namespace: rolebinding.metadata.namespace,
                kind: "RoleBinding" } )
  WITH rolebinding
  UNWIND rolebinding.subjects as subject
  MATCH (s:ServiceAccount {name: subject.name,
                           namespace: subject.namespace})
  MATCH (cr:ClusterRole {
                                      kind: rolebinding.roleRef.kind,
                                      name: rolebinding.roleRef.name
                     })
  MERGE (s)-[:RoleBinding  {name: rolebinding.metadata.name,
                            namespace: rolebinding.metadata.namespace,
                            kind: "RoleBinding" }
            ]->(cr)
  WITH rolebinding
  MATCH (r:Role {
                                      kind: rolebinding.roleRef.kind,
                                      name: rolebinding.roleRef.name,
                                      namespace: rolebinding.roleRef.namespace
                     })
  MERGE(s)-[:RoleBinding  {name: rolebinding.metadata.name,
                           namespace: rolebinding.metadata.namespace,
                                      kind: "RoleBinding" }
            ]->(r)

