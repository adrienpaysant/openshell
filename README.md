# OpenShell avec Podman

Ce dépôt contient un POC local d'OpenShell sur macOS Apple Silicon. Le CLI et
le Gateway OpenShell tournent nativement sur macOS ; Podman Machine rootless
sert de runtime de conteneurs. La VM utilisée pour ce POC dispose de 2 CPU et
2 GiB de mémoire : gardez un seul sandbox actif à la fois.

## OpenShell : fonctionnement et enjeux

OpenShell fournit une couche de contrôle pour exécuter des agents IA dans des
environnements isolés. L'objectif est de leur permettre de travailler de
manière autonome tout en contrôlant leur accès aux ressources du système.

Par exemple, Codex peut être autorisé à lire et modifier du code, installer des
packages et des skills, exécuter des scripts et des tests, ou accéder à certains
services externes. En parallèle, l'environnement vise à limiter l'accès aux
credentials de l'hôte, aux réseaux internes non autorisés, aux fichiers
sensibles et aux environnements de production.

Podman assure l'exécution des conteneurs. OpenShell gère leur cycle de vie et
les mécanismes de contrôle associés. Les garanties effectives dépendent de la
configuration et du runtime ; elles doivent être vérifiées par des essais, et
ne sont pas présumées acquises par ce POC.

### Vision entreprise

À terme, l'objectif serait de proposer un catalogue de sandboxes standardisés,
maintenus par les équipes Platform et DevSecOps. Chaque profil disposerait de
ses propres outils, permissions et règles de sécurité. Par exemple :

- `dev-standard` : développement, installation de packages et skills.
- `dev-restricted` : développement sur des projets sensibles.
- `devops` : Terraform, Ansible et accès contrôlés aux APIs internes.
- `security-audit` : analyse et accès en lecture seule.

Les utilisateurs pourraient ainsi disposer d'environnements adaptés à leurs
besoins sans gérer eux-mêmes les politiques de sécurité.

### Enjeux restant à étudier

Ce POC reste une expérimentation locale. Avant toute industrialisation, il
faudra étudier notamment :

- **IAM et RBAC** : qui peut créer et administrer les sandboxes ?
- **Secrets** : comment fournir les credentials sans les exposer ?
- **Supply chain** : comment contrôler les skills, packages et images utilisés ?
- **Réseau** : comment maîtriser les accès aux services internes et externes ?
- **Audit** : comment tracer les actions des agents ?
- **Isolation** : quelles garanties selon le runtime utilisé ?
- **Exploitation** : comment gérer le provisioning, les quotas, les mises à
  jour et le cycle de vie ?

L'objectif final est de fournir aux équipes un environnement de travail
autonome et flexible, tout en conservant une gouvernance centralisée des accès
et des ressources.

## Démarrage rapide

Prérequis : macOS arm64, Homebrew, Podman 5 ou plus récent, Podman Machine
active avec cgroups v2 et socket rootless joignable.

```bash
bash scripts/audit.sh
bash scripts/install.sh
GATEWAY_CONFIG="$PWD/gateway.toml" bash scripts/configure-gateway.sh
bash scripts/build-agent-image.sh
bash scripts/create-sandbox.sh demo
```

L'image est construite en `linux/arm64` depuis `Containerfile`. La commande de
configuration ci-dessus place `gateway.toml` à la racine du dépôt ; ce fichier
est ignoré par Git. Le script refuse de l'écraser s'il existe déjà. Il effectue
un préflight puis redémarre le service Gateway Homebrew avec cette configuration.
Sans `GATEWAY_CONFIG`, le chemin par défaut est
`~/.config/openshell/gateway.toml`, que le script refuse également d'écraser.

## Observer et supprimer le sandbox

Dans la VM Podman, inspectez les conteneurs créés par OpenShell :

```bash
podman ps -a --filter name=openshell
podman inspect <nom-conteneur>
podman top <nom-conteneur>
podman stats --no-stream <nom-conteneur>
podman inspect <nom-conteneur> --format '{{json .Mounts}}'
podman inspect <nom-conteneur> --format '{{json .NetworkSettings.Networks}}'
```

OpenShell crée un conteneur workload et un supervisor par sandbox. Ne modifiez
ni ne supprimez ces conteneurs directement pendant qu'OpenShell les gère ;
utilisez `bash scripts/cleanup.sh demo` ou `openshell sandbox delete demo`.

## Documentation et tests

- [Architecture et composants](architecture.md)
- [Installation et configuration](installation.md)
- [Filesystem](tests/filesystem.md)
- [Réseau](tests/network.md)
- [Processus](tests/process.md)
- [Providers](tests/providers.md)
- [Isolation entre sandboxes](tests/isolation.md)
- [Notes sur les policies](configuration/policies/README.md)

Le smoke test local vérifie les fichiers attendus et la syntaxe des scripts :

```bash
bash tests/scripts-smoke.sh && echo "Smoke test réussi"
```

Les états TLS, la base de données, les credentials et les sandboxes restent
dans les répertoires utilisateur OpenShell et Podman, jamais dans Git.
`cleanup.sh` ne supprime que le sandbox nommé. Aucun test de policy n'est
déclaré réussi avant son exécution effective.
