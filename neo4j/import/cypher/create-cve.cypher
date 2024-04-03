CREATE (cve:CVE {name: "CVE-202212345", severity: "HIGH"})
WITH cve

MATCH
  (container:Containers)
  WHERE container.image = "ghcr.io/thomasfricke/docker-imagetragick:main" AND cve.name = "CVE-202212345"
CREATE (container)-[r:VULNERABLE]->(cve)
