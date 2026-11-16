# Procédures de test

Les scénarios couvrent des comportements distincts. Tous restent **non qualifiés** jusqu'à exécution et collecte de preuves.

## Préparation commune

```bash
openshell status
bash scripts/status.sh
openshell sandbox exec demo -- id
```

Si `sandbox exec` échoue, arrêter les scénarios dépendants et noter l'erreur comme blocage fonctionnel, pas comme refus de policy ou réussite d'isolation. Pour tester une policy, la fournir explicitement à la création du sandbox ou appliquer une commande documentée dans [les snippets](../configuration/policies/README.md). Filesystem, Landlock et process prennent effet au démarrage ; le réseau peut être actualisé à chaud. Vérifier la policy et sa révision avant d'attribuer un résultat à une règle.

## Relevé commun

Noter version OpenShell, sandbox, policy/révision, commande, code retour, sortie, heure, attendu et observé. Ne pas consigner de credentials. Distinguer panne de transport, DNS ou connectivité d'un refus explicite de policy.

## Scénarios

- [A. Accès filesystem](filesystem.md)
- [B. Accès réseau](network.md)
- [C. Processus et privilèges](process.md)
- [D. Providers et credentials](providers.md)
- [E. Isolation entre sandboxes](isolation.md)
