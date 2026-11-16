# B. Accès réseau

Voir [le protocole commun](README.md) avant l'exécution. Le dépôt ne fournit
pas de policy réseau appliquée par défaut.

Établir d'abord la connectivité sans changer de policy :

```bash
openshell sandbox exec demo -- /bin/sh -lc 'getent hosts example.com'
openshell sandbox exec demo -- curl -I --max-time 10 https://example.com
```

Pour tester une permission OpenShell, créer un sandbox de test avec un snippet
réseau de [la référence locale](../configuration/policies/README.md#reseau), ou
appliquer une mise à jour documentée. Vérifier la policy et sa révision, puis
comparer la destination autorisée avec une destination témoin.

Un timeout ou un échec DNS ne prouve pas un refus de policy. Relever DNS, code
de retour, sortie, policy/révision et événement de refus éventuel.

**État : non qualifié.**
