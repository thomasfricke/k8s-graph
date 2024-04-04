//load clusterrolebindings

CALL apoc.load.json("${API_SERVER}/apis/rbac.authorization.k8s.io/v1/clusterrolebindings")
YIELD value as clusterrolebindinglist

WITH clusterrolebindinglist
UNWIND clusterrolebindinglist.items AS clusterrolebinding
  MERGE (crb:ClusterRoleBinding {name: clusterrolebinding.metadata.name,
                kind: "ClusterRoleBinding" } )
  WITH clusterrolebinding 
  UNWIND clusterrolebinding.subjects as subject
  MATCH (s:ServiceAccount {name: subject.name,
                           namespace: subject.namespace})
  MATCH (cr:ClusterRole {
                                      kind: clusterrolebinding.roleRef.kind,
                                      name: clusterrolebinding.roleRef.name
                     }) 
  MERGE (s)-[:ClusterRoleBinding  {name: clusterrolebinding.metadata.name,
                                      kind: "ClusterRoleBinding" }
            ]->(cr)
  WITH clusterrolebinding, subject
  MATCH (r:ROLE {
                                      kind: clusterrolebinding.roleRef.kind,
                                      name: clusterrolebinding.roleRef.name,
                                      namespace: subject.namespace
                     })
  MERGE(s)-[:ClusterRoleBinding  {name: clusterrolebinding.metadata.name,
                                      kind: "ClusterRoleBinding" }
            ]->(r) 
