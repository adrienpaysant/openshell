# Installation et configuration

## 1. Audit

```bash
bash scripts/audit.sh
podman info
podman system connection list
```

L'audit doit montrer Podman 5+, machine active, Linux arm64 dans l'hôte distant,
cgroups v2 et `remoteSocket.exists=true`. Sur macOS, le socket est dans la VM
et la connexion Podman passe par SSH ; ne pas essayer de monter un chemin socket
macOS arbitraire dans les sandboxes.

## 2. Installer OpenShell

`scripts/install.sh` appelle l'installateur maintenu par NVIDIA :

```bash
bash scripts/install.sh
openshell --version
openshell status
```

Sur macOS, NVIDIA distribue CLI, Gateway et prover par Homebrew et lance le
Gateway sur `https://localhost:17670`.

## 3. Configurer Podman

La configuration minimale validée par le schéma installé se trouve dans
`configuration/gateway.toml.example`. Elle utilise TOML version 2 et sélectionne
`podman`. Le chemin de socket est omis pour que le driver détecte la connexion
Podman Machine.

```bash
bash scripts/configure-gateway.sh
openshell status
```

Par défaut, le script copie l'exemple vers `~/.config/openshell/gateway.toml`.
Pour utiliser une configuration locale dans ce dépôt (fichier ignoré par Git),
passez le chemin avec `GATEWAY_CONFIG` :

```bash
GATEWAY_CONFIG="$PWD/gateway.toml" bash scripts/configure-gateway.sh
```

Dans les deux cas, le script refuse d'écraser un fichier existant, exécute
`openshell-gateway config preflight`, puis redémarre le service Homebrew.
Le premier `openshell status` immédiatement après redémarrage peut arriver
avant que le listener soit prêt ; réessayer après quelques secondes.

## 4. Construire et créer un sandbox

```bash
bash scripts/build-agent-image.sh
podman image inspect localhost/openshell-poc-agent:dev
bash scripts/create-sandbox.sh demo
podman ps -a --filter name=openshell
```

L'image Ubuntu 24.04 arm64 contient shell et outils de diagnostic. OpenShell
exige que son workspace soit accessible à l'identité runtime ; le Containerfile
crée `/workspace` et en attribue la propriété à l'utilisateur agent.

## Dépannage

- `WorkspaceValidationFailed`: vérifier que `WORKDIR` existe et est utilisable
  par l'UID sélectionné dans l'image. Reconstruire puis choisir un nouveau nom
  de sandbox si l'ancien est en phase Error.
- `Connection refused` après redémarrage du Gateway : attendre quelques
  secondes puis relancer `openshell status`.
- Ressources : la Podman Machine observée a 2 CPU / 2 GiB ; les exemples du POC
  limitent un sandbox à 0,5 CPU / 384 MiB.
- Le driver peut créer workload et supervisor sans que toutes les opérations
  CLI soient automatiquement qualifiées. Relever toute erreur de transport,
  phase et logs comme résultat de test.

## Secrets et état

Ne jamais ajouter les fichiers suivants au dépôt : certificats et clés mTLS,
base OpenShell, credentials provider, fichiers `.env` contenant des clés.
Utiliser le coffre de credentials OpenShell pour les providers ; ne pas passer
une clé par `--env` ni la construire dans l'image.
