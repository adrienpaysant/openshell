# C. Processus et privilèges

Voir [le protocole commun](README.md) avant l'exécution.

```bash
openshell sandbox exec demo -- id
openshell sandbox exec demo -- /bin/sh -lc 'touch /root/openshell-poc-test'
openshell sandbox exec demo -- /bin/sh -lc 'mkdir -p /mnt/openshell-poc && mount -t tmpfs tmpfs /mnt/openshell-poc'
```

Consigner UID/GID numériques et codes de retour. Un UID non nul n'établit pas à
lui seul l'absence de capabilities. L'écriture sous `/root` et le montage
devraient échouer pour un processus sans les privilèges correspondants. Pour
fixer explicitement l'identité, voir [le snippet process](../configuration/policies/README.md#identite-processus) ; les champs `process` prennent effet à la création du sandbox.

**État : non qualifié.**
