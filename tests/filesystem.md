# A. Accès filesystem

Voir [le protocole commun](README.md) avant l'exécution.

```bash
openshell sandbox exec demo -- /bin/sh -lc 'printf poc > /workspace/probe.txt && cat /workspace/probe.txt'
openshell sandbox exec demo -- /bin/sh -lc 'test -r /etc/shadow && echo readable || echo not-readable'
openshell sandbox exec demo -- /bin/sh -lc 'cat /proc/self/mountinfo'
openshell sandbox exec demo -- rm -f /workspace/probe.txt
```

Le marqueur doit être relu depuis le workspace. `/etc/shadow` est un fichier du
conteneur : son inaccessibilité ne démontre pas l'isolation d'un fichier hôte.
Comparer `mountinfo` à la policy active et identifier les montages partagés.
Pour appliquer les exemples de restriction filesystem, voir
[les snippets](../configuration/policies/README.md#filesystem-et-landlock).

**État : non qualifié.**
