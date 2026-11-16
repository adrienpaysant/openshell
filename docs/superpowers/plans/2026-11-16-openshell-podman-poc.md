# POC OpenShell et Podman Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fournir un POC OpenShell local, reproductible avec Podman seul, et documenter des tests d'isolation réellement exécutables.

**Architecture:** Le Gateway et le CLI sont installés nativement sur macOS et le Gateway sélectionne le driver Podman. Les scripts du dépôt construisent une image OCI d'agent arm64, pilotent le Gateway et capturent des résultats de tests sans inclure de secrets.

**Tech Stack:** macOS, Homebrew, NVIDIA OpenShell, Podman 6.2 rootless via Podman Machine, POSIX shell, TOML, Markdown.

**Spec:** `docs/superpowers/specs/2026-11-16-openshell-podman-poc-design.md`

## Global Constraints

- Podman exclusivement ; ni Docker, ni Docker Desktop, ni Kubernetes.
- Ne pas arrêter, redimensionner ou reconfigurer la Podman Machine.
- Gateway natif macOS ; `compute_driver = "podman"` et schéma TOML version 2.
- Toute écoute Gateway doit rester sur loopback avec TLS/mTLS fourni par le paquet.
- Ne jamais placer credentials, certificats, base SQLite ou état OpenShell dans Git.
- Les résultats de sécurité sont « observés » uniquement après exécution.

## Review Focus

- Podman Machine indisponible : `status.sh` doit échouer avec un diagnostic lisible.
- Config TOML invalide : `configure-gateway.sh` doit lancer le préflight avant tout redémarrage.
- Image construite sur Apple Silicon : le script doit demander explicitement `linux/arm64`.
- Secret absent : aucun script ne doit l'écrire ni l'afficher.
- Ressources limitées : les scripts créent un seul sandbox par défaut et proposent des limites modestes.

---

### Task 1: Structure, garde-fous et image d'agent

**Files:**
- Create: `openshell-poc/Containerfile`
- Create: `openshell-poc/.gitignore`
- Create: `openshell-poc/scripts/build-agent-image.sh`
- Create: `openshell-poc/scripts/audit.sh`
- Test: `openshell-poc/tests/scripts-smoke.sh`

**Interfaces:**
- Produces: image locale `localhost/openshell-poc-agent:dev` et scripts shell exécutables.

- [ ] Écrire le test smoke qui vérifie les fichiers attendus et `bash -n`.
- [ ] L'exécuter et confirmer son échec avant création des scripts.
- [ ] Créer un Containerfile OCI arm64 minimal sans credentials et les scripts idempotents.
- [ ] Rejouer le test puis exécuter `podman build` seulement après validation utilisateur de l'installation.

### Task 2: Configuration et cycle de vie Gateway

**Files:**
- Create: `openshell-poc/configuration/gateway.toml.example`
- Create: `openshell-poc/scripts/install.sh`
- Create: `openshell-poc/scripts/configure-gateway.sh`
- Create: `openshell-poc/scripts/status.sh`
- Create: `openshell-poc/scripts/create-sandbox.sh`
- Create: `openshell-poc/scripts/cleanup.sh`
- Test: `openshell-poc/tests/scripts-smoke.sh`

**Interfaces:**
- Consumes: image construite par Task 1 et configuration copiée hors Git.
- Produces: Gateway préflighté et sandbox nommé avec des limites CPU/mémoire.

- [ ] Étendre le smoke test avec le schéma TOML v2 et les noms des commandes.
- [ ] Vérifier l'échec attendu avant implémentation.
- [ ] Implémenter les scripts avec installation officielle NVIDIA, préflight et aucun secret versionné.
- [ ] Vérifier syntaxe et préflight une fois OpenShell installé.

### Task 3: Policies et documentation opératoire

**Files:**
- Create: `openshell-poc/README.md`
- Create: `openshell-poc/architecture.md`
- Create: `openshell-poc/installation.md`
- Create: `openshell-poc/configuration/policies/README.md`
- Create: `openshell-poc/tests/filesystem.md`
- Create: `openshell-poc/tests/network.md`
- Create: `openshell-poc/tests/process.md`
- Create: `openshell-poc/tests/providers.md`
- Create: `openshell-poc/tests/isolation.md`
- Modify: `openshell-poc/tests/scripts-smoke.sh`

**Interfaces:**
- Consumes: commandes exactes validées durant Tasks 1–2.
- Produces: procédures reproductibles séparant résultat attendu et résultat observé.

- [ ] Tester l'absence de références Docker/Kubernetes et la présence des documents obligatoires.
- [ ] Confirmer l'échec initial.
- [ ] Écrire la documentation et les scénarios sans inventer de résultat.
- [ ] Exécuter le smoke test et compléter les résultats observés après chaque test réel.

### Task 4: Installation, qualification et essais réels

**Files:**
- Modify: `openshell-poc/tests/*.md`
- Modify: `openshell-poc/README.md`

**Interfaces:**
- Consumes: scripts, image, configuration et procédures précédentes.
- Produces: résultats d'installation, sandbox et politiques, avec les limitations constatées.

- [ ] Installer OpenShell avec la méthode officielle après contrôle du script téléchargé.
- [ ] Configurer puis préflighter le Gateway Podman, démarrer son service et vérifier l'API.
- [ ] Construire l'image, créer deux sandboxes et inspecter Podman.
- [ ] Exécuter les cinq familles de tests et consigner uniquement les sorties observées.

## Self-review

- Les quatre tâches couvrent structure, Gateway, documentation et qualification réelle.
- Les échecs prévisibles (VM indisponible, TOML invalide, arm64, secrets, ressources) sont couverts par tests ou diagnostics.
- Aucun secret n'est une entrée de fichier versionné ; les résultats restent « non exécuté » avant la qualification.
