# D. Providers et credentials

Voir [le protocole commun](README.md) avant l'exécution. Utiliser uniquement un credential de test autorisé et le flux sécurisé documenté par la CLI installée. La création et l'attachement du provider dépendent du profil et de la version ; consulter l'aide locale :

```bash
openshell provider --help
openshell profile --help
openshell sandbox create --help
```

Vérifier que l'agent peut appeler le service voulu et que le secret brut n'apparaît pas dans son environnement ni dans les logs. Examiner la policy effective pour distinguer les règles de base des règles ajoutées par le provider :

```bash
openshell policy get demo --base
openshell policy get demo --full
```

Ne pas placer un secret dans une commande, un fichier suivi par Git, une image ou une sortie de diagnostic. Révoquer/supprimer le provider de test selon l'aide de la CLI après l'essai.

**État : non qualifié ; aucun credential de test n'est fourni.**
