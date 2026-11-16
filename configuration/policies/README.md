# Snippets de policies OpenShell

Ces extraits reprennent le schéma YAML v1 documenté pour OpenShell 0.1.8. Ce sont des exemples de champs documentés, pas des profils complets, et ils ne sont ni appliqués par le POC ni qualifiés comme résultats de sécurité. Adapter les chemins à l'image et valider avec la version installée. Filesystem, Landlock et process sont statiques au démarrage ; le réseau est dynamique.

## Filesystem et Landlock

```yaml
version: 1
filesystem_policy:
  include_workdir: true
  read_only: [/usr, /lib, /etc]
  read_write: [/tmp]
landlock:
  compatibility: best_effort
```

`best_effort` autorise le démarrage sans les règles filesystem si leur application échoue, avec une alerte de haute sévérité dans les logs. Pour rendre leur application obligatoire :

```yaml
landlock:
  compatibility: hard_requirement
```

Le noyau doit prendre en charge Landlock ABI v3 ou ultérieur.

## Identité processus

Exemple de la référence. Choisir une identité compatible avec le propriétaire du workspace de l'image :

```yaml
process:
  run_as_user: "1500"
  run_as_group: "1500"
```

Les UID/GID numériques sont compris entre 1 et 4294967294. Ce réglage prend effet à la création du sandbox.

## Réseau

Extrait de la référence : autoriser `/usr/bin/curl` à effectuer des requêtes REST en lecture seule vers l'API GitHub en HTTPS.

```yaml
network_policies:
  github_api:
    name: github-api-readonly
    endpoints:
      - host: api.github.com
        port: 443
        protocol: rest
        enforcement: enforce
        access: read-only
    binaries:
      - path: /usr/bin/curl
```

Mise à jour incrémentale documentée d'une policy réseau active :

```bash
openshell policy update demo \
  --rule-name github_readonly \
  --binary /usr/bin/curl \
  --add-endpoint api.github.com:443:read-only:rest:enforce \
  --wait
```

Le chemin du binaire doit correspondre à celui du sandbox. Les règles réseau associent les binaires aux destinations ; selon la documentation, toute connexion sortante non permise est refusée.

## Création et inspection

```bash
openshell sandbox create --name demo-policy --policy ./policy.yaml -- /bin/bash
openshell policy get demo-policy --base
openshell policy get demo-policy --full
openshell policy list demo-policy
```

Enregistrer le YAML dans `policy.yaml` avant la création. `--full` montre la policy effective, y compris les règles ajoutées par les providers. Les snippets ci-dessus ne forment pas une policy prête à appliquer à l'image de ce POC.

## Sources NVIDIA

- [Vue d'ensemble des policies (v0.1.8)](https://docs.nvidia.com/openshell/v0.1.8/how-it-works/policies/overview)
- [Schéma des policies (v0.1.8)](https://docs.nvidia.com/openshell/v0.1.8/how-it-works/policies/schema)
- [Gestion des policies](https://docs.nvidia.com/openshell/latest/how-it-works/policies/manage-policies)
