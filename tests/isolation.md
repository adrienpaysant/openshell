# E. Isolation entre sandboxes

Voir [le protocole commun](README.md) avant l'exécution. Ce scénario requiert deux sandboxes simultanés ; chacun utilise 500m CPU et 384 MiB sur la VM décrite comme ayant 2 CPU et 2 GiB.

```bash
bash scripts/create-sandbox.sh iso-a
bash scripts/create-sandbox.sh iso-b
openshell sandbox exec iso-a -- /bin/sh -lc 'printf private > /workspace/isolation-marker'
openshell sandbox exec iso-b -- /bin/sh -lc 'test ! -e /workspace/isolation-marker'
openshell sandbox exec iso-a -- /bin/sh -lc 'sleep 60'
openshell sandbox exec iso-b -- ps -eo pid,user,args
bash scripts/cleanup.sh iso-a
bash scripts/cleanup.sh iso-b
```

Le deuxième `test` doit réussir (code 0), indiquant que le marqueur est absent de B. Les commandes `sleep` et `ps` ne sont pas simultanées ; elles donnent seulement un aperçu et ne qualifient pas l'isolation des processus. Si la création ou `exec` échoue, consigner l'erreur comme problème de fonctionnement, pas comme résultat de sécurité.

**État : non qualifié.**
