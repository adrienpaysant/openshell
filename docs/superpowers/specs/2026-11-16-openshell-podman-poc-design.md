# POC OpenShell et Podman — conception

## Intention

Créer un POC local, documenté et réutilisable pour étudier les sandboxes
NVIDIA OpenShell sur macOS Apple Silicon, avec Podman comme seul runtime de
conteneurs. Le POC doit permettre de construire l'image de l'agent avec
`podman build`, puis d'exercer les contrôles d'accès réels d'OpenShell.

## Objectifs

- Installer les binaires OpenShell officiels de manière native sur macOS.
- Exécuter le Gateway nativement et sélectionner explicitement le driver
  `podman`.
- Laisser la Podman Machine existante inchangée : 2 CPU et 2 GiB.
- Construire une image d'agent Linux arm64 locale avec `podman build`.
- Créer deux sandboxes et documenter les résultats observés pour les accès
  filesystem, réseau, processus, providers et l'isolation inter-sandbox.
- Ne jamais versionner de clé, certificat, base Gateway ou état de sandbox.

## Hors périmètre

- Docker, Docker Desktop et Kubernetes.
- Redimensionnement, arrêt ou reconfiguration de la Podman Machine.
- Exposition du Gateway hors de la boucle locale.
- Déclarer un contrôle de sécurité effectif avant son test réel.

## Architecture retenue

Le CLI, le policy prover et le Gateway s'exécutent nativement sur macOS, via
la distribution NVIDIA officielle. Le Gateway utilise le driver Podman et sa
connexion Podman Machine existante pour créer les superviseurs et sandboxes
dans la VM Linux rootless. Les agents s'exécutent dans des images OCI arm64
construites localement avec Podman.

```text
openshell CLI (macOS) -> Gateway (macOS, mTLS) -> API Podman Machine
                                                     -> supervisor
                                                     -> sandbox agent
```

Le Gateway est le composant de confiance qui pilote Podman. Les agents ne
reçoivent ni socket Podman ni credentials de providers : le supervisor
médie les opérations réseau autorisées.

## Approches considérées

1. Gateway natif macOS, sandboxes Podman — retenue. C'est le chemin le plus
   simple, sans montage du socket dans un conteneur de contrôle.
2. Gateway dans Podman — officiellement possible, mais impose de monter le
   socket Podman dans le Gateway et ajoute une frontière inutile au POC.
3. Kubernetes — écarté : il remplacerait le driver Podman et dépasse les
   ressources disponibles de la VM.

## Contraintes et risques connus

- La documentation NVIDIA exige Podman 5.x, cgroups v2 et un socket
  utilisateur actif. La VM fournit cgroups v2 et le socket rootless, mais
  Podman 6.2.0 devra être qualifié par un vrai sandbox.
- NVIDIA documente la détection des sockets Podman Machine sur macOS, mais la
  plateforme Podman/macOS devra être validée par l'exécution, sans promesse
  de qualification de production.
- 2 GiB de mémoire limite le POC à un ou deux petits sandboxes séquentiels.
- L'image d'agent ne doit contenir aucun credential. Les providers sont créés
  par l'interface OpenShell à partir de variables d'environnement éphémères.

## Réutilisation

`openshell-poc/` contient les artefacts versionnés : Containerfile, scripts,
exemples de configuration et protocoles de test. Les scripts refusent les
variables ou fichiers de secrets manquants et stockent l'état local sous un
répertoire ignoré par Git.
