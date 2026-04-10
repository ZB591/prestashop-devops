# 🛒 PrestaShop DevOps Infrastructure

Infrastructure de production complète pour PrestaShop avec Docker, monitoring, CI/CD et backup automatique.

## 🏗️ Architecture

```
Internet
    │
    ▼
[Nginx :80/:443]  ← Reverse Proxy SSL
    │
    ▼
[PrestaShop :80]  ← Application
    │
    ▼
[MySQL :3306]     ← Base de données
```

### Services
| Service | Image | Port | Rôle |
|---------|-------|------|------|
| nginx | nginx:alpine | 80, 443 | Reverse proxy SSL |
| prestashop | custom | - | Application e-commerce |
| mysql | mysql:8.0 | 3306 | Base de données |
| phpmyadmin | phpmyadmin:latest | 8080 | Admin BDD |
| prometheus | prom/prometheus | 9090 | Collecte métriques |
| grafana | grafana/grafana | 3000 | Dashboard monitoring |
| cadvisor | gcr.io/cadvisor | 8082 | Métriques containers |
| node-exporter | prom/node-exporter | 9100 | Métriques système |
| alertmanager | prom/alertmanager | 9093 | Gestion alertes |
| backup | mysql:8.0 | - | Backup automatique |

## 🚀 Mise en place

### Prérequis
- Docker Desktop
- Git
- OpenSSL

### Installation

1. **Cloner le projet**
```bash
git clone https://github.com/TON_USERNAME/prestashop-devops.git
cd prestashop-devops
```

2. **Configurer les variables d'environnement**
```bash
cp .env.example .env
# Modifier les valeurs dans .env
```

3. **Générer les certificats SSL**
```bash
mkdir -p nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/ssl/key.pem \
  -out nginx/ssl/cert.pem \
  -subj "//C=FR\ST=Paris\L=Paris\O=PrestaShop\CN=localhost"
```

4. **Lancer l'infrastructure**
```bash
docker compose up -d
```

5. **Vérifier les containers**
```bash
docker compose ps
```

## 🌐 Accès

| Service | URL | Identifiants |
|---------|-----|--------------|
| PrestaShop | http://localhost | Définis dans .env |
| phpMyAdmin | http://localhost:8080 | root / voir .env |
| Grafana | http://localhost:3000 | admin / voir .env |
| Prometheus | http://localhost:9090 | - |
| cAdvisor | http://localhost:8082 | - |
| Alertmanager | http://localhost:9093 | - |

## 📊 Monitoring

### Grafana
1. Accéder à http://localhost:3000
2. Ajouter Prometheus comme datasource : `http://prometheus:9090`
3. Importer les dashboards depuis `monitoring/grafana/dashboards/`

### Prometheus
- Accéder à http://localhost:9090
- Targets disponibles : node-exporter, cadvisor, prestashop

## 🔄 CI/CD GitHub Actions

Le pipeline `.github/workflows/ci-cd.yml` effectue automatiquement :
1. **Build** de l'image Docker PrestaShop
2. **Push** sur Docker Hub
3. **Déploiement** sur le serveur de production

### Secrets requis
| Secret | Description |
|--------|-------------|
| `DOCKERHUB_USERNAME` | Nom d'utilisateur Docker Hub |
| `DOCKERHUB_TOKEN` | Token d'accès Docker Hub |

## 💾 Backup

Le backup automatique s'exécute via le container `ps-backup` :
```bash
# Voir les logs de backup
docker logs ps-backup

# Accéder aux backups
docker exec ps-backup ls /backups/
```

## 🛠️ Scripts utiles

```bash
# Démarrer l'infrastructure
docker compose up -d

# Arrêter l'infrastructure
docker compose down

# Voir les logs
docker compose logs -f

# Redémarrer un service
docker compose restart prestashop

# Nettoyer les volumes
docker compose down -v
```

## 📁 Structure du projet

```
prestashop-devops/
├── .env                          # Variables d'environnement
├── .github/
│   └── workflows/
│       └── ci-cd.yml            # Pipeline CI/CD
├── Dockerfile                   # Image PrestaShop custom
├── docker-compose.yml           # Orchestration des services
├── nginx/
│   ├── nginx.conf               # Configuration Nginx
│   └── ssl/                     # Certificats SSL
├── monitoring/
│   ├── prometheus/
│   │   └── prometheus.yml       # Config Prometheus
│   ├── grafana/
│   │   └── dashboards/          # Dashboards Grafana
│   └── alertmanager/
│       └── alertmanager.yml     # Config alertes
└── backup/
    └── backup.sh                # Script de backup
```

## 👤 Auteur

**Nacer** — Formation DevOps
