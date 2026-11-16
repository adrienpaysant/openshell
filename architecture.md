# Architecture

```text
openshell CLI (macOS)
        │ HTTPS / mTLS
        ▼
OpenShell Gateway (macOS, Homebrew service)
        │ Podman API socket via Podman Machine SSH connection
        ▼
Podman Machine (Linux arm64, rootless, cgroups v2)
        ├── supervisor OpenShell
        └── workload (agent)
```

Le CLI transmet au Gateway les demandes de cycle de vie. Le Gateway valide la
configuration et la policy, puis demande à Podman de créer les conteneurs et
leurs ressources. Le supervisor applique la médiation réseau et credentials ;
le runtime de confiance dans le workload démarre l'agent. L'agent ne reçoit
pas le socket Podman.

Cycle : `sandbox create` → validation du noyau et policy → création workload +
supervisor → exécution de l'agent → stop/start ou delete par le Gateway.

La frontière reste celle de conteneurs Linux rootless dans la VM Podman, pas
une VM distincte par agent. Les résultats sont un POC local, pas une
qualification de sécurité de production.
