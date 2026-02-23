# 🚀 Task Manager Microservices

Architecture microservices complète avec API Gateway, services découplés, bases de données séparées, Docker et Kubernetes.

## 📊 Architecture
```
Client (Browser/Postman)
         ↓
   API Gateway (3000)
         ↓
    ┌────┴────┬────────┐
    ↓         ↓        ↓
Auth (3001) Projects Tasks (3003)
    ↓       (3002)     ↓
    ↓         ↓        ↓
  auth_db  proj_db  tasks_db
```

### **Principes microservices appliqués :**
- ✅ **API Gateway Pattern** - Point d'entrée unique
- ✅ **Database per Service** - Isolation des données
- ✅ **Service Isolation** - Services complètement découplés
- ✅ **Docker Containerization** - Environnements reproductibles
- ✅ **Health Checks** - Monitoring et auto-healing

## 🛠️ Technologies

- **Backend :** Ruby 3.2.2, Rails 8.1.2 (API mode)
- **Base de données :** PostgreSQL 16
- **Authentification :** JWT (JSON Web Tokens)
- **Containerisation :** Docker, Docker Compose
- **Orchestration :** Kubernetes (Minikube)
- **Tests :** RSpec
- **CI/CD :** GitHub Actions

## 🏗️ Services

### **1. API Gateway (Port 3000)**
Point d'entrée unique pour tous les clients. Gère :
- Authentification centralisée (vérification JWT)
- Routage vers les services appropriés
- Ajout du header `X-User-Id` pour les services downstream

### **2. Auth Service (Port 3001)**
Gestion de l'authentification et des utilisateurs :
- `POST /signup` - Créer un compte
- `POST /login` - Se connecter
- `POST /verify` - Vérifier un token JWT

**Base de données :** `auth_service_development`

### **3. Projects Service (Port 3002)**
Gestion des projets :
- `GET /projects` - Liste des projets
- `POST /projects` - Créer un projet
- `GET /projects/:id` - Détails d'un projet
- `PUT /projects/:id` - Modifier un projet
- `DELETE /projects/:id` - Supprimer un projet

**Base de données :** `projects_service_development`

### **4. Tasks Service (Port 3003)**
Gestion des tâches :
- `GET /projects/:project_id/tasks` - Liste des tâches d'un projet
- `POST /projects/:project_id/tasks` - Créer une tâche
- `GET /tasks/:id` - Détails d'une tâche
- `PUT /tasks/:id` - Modifier une tâche
- `PATCH /tasks/:id/toggle` - Toggle statut completed
- `DELETE /tasks/:id` - Supprimer une tâche

**Base de données :** `tasks_service_development`

## 🚀 Installation et Lancement

### **Prérequis**
- Docker Desktop
- Docker Compose

### **Lancement avec Docker Compose**
```bash
# Cloner le repository
git clone https://github.com/giresse21/task-manager-microservices.git
cd task-manager-microservices

# Démarrer tous les services
docker-compose up

# L'API sera accessible sur http://localhost:3000
```

### **Arrêter les services**
```bash
docker-compose down
```

### **Supprimer les volumes (données)**
```bash
docker-compose down -v
```

## 📡 Utilisation de l'API

### **1. Créer un compte**
```bash
curl -X POST http://localhost:3000/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

**Réponse :**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### **2. Se connecter**
```bash
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### **3. Créer un projet** (authentification requise)
```bash
curl -X POST http://localhost:3000/projects \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "name": "Mon Projet",
    "description": "Description du projet",
    "color": "#3498db"
  }'
```

### **4. Créer une tâche** (authentification requise)
```bash
curl -X POST http://localhost:3000/projects/1/tasks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "title": "Ma première tâche",
    "description": "Description de la tâche",
    "priority": "high",
    "due_date": "2026-03-01"
  }'
```

### **5. Lister les projets**
```bash
curl http://localhost:3000/projects \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### **6. Toggle une tâche**
```bash
curl -X PATCH http://localhost:3000/tasks/1/toggle \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 🗄️ Bases de données

Chaque service possède sa propre base de données PostgreSQL :

| Service | Base de données | Port (local) |
|---------|----------------|--------------|
| Auth | `auth_service_development` | 5435 |
| Projects | `projects_service_development` | 5436 |
| Tasks | `tasks_service_development` | 5437 |

### **Accéder à une base de données**
```bash
# Auth DB
psql -h localhost -p 5435 -U postgres -d auth_service_development

# Projects DB
psql -h localhost -p 5436 -U postgres -d projects_service_development

# Tasks DB
psql -h localhost -p 5437 -U postgres -d tasks_service_development
```

## 🐳 Architecture Docker

### **Images construites**
- `task-manager-microservices-auth-service`
- `task-manager-microservices-projects-service`
- `task-manager-microservices-tasks-service`
- `task-manager-microservices-api-gateway`

### **Volumes persistants**
- `auth_db_data` - Données Auth Service
- `projects_db_data` - Données Projects Service
- `tasks_db_data` - Données Tasks Service

### **Réseau**
Docker Compose crée un réseau privé où les services communiquent via leurs noms :
- `auth-service:3001`
- `projects-service:3002`
- `tasks-service:3003`

## ☸️ Déploiement Kubernetes

*(Documentation Kubernetes à venir)*

### **Commandes utiles**
```bash
# Voir les conteneurs
docker-compose ps

# Voir les logs
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f api-gateway

# Rebuild les images
docker-compose up --build

# Accéder à un conteneur
docker-compose exec auth-service bash
```

## 🧪 Tests

*(Tests à venir avec RSpec)*

## 📈 Évolutions futures

- [ ] Tests unitaires et d'intégration (RSpec)
- [ ] CI/CD avec GitHub Actions
- [ ] Déploiement Kubernetes complet
- [ ] Service mesh (Istio)
- [ ] Monitoring (Prometheus + Grafana)
- [ ] Tracing distribué (Jaeger)
- [ ] Rate limiting
- [ ] Caching (Redis)
- [ ] Message queue (RabbitMQ/Kafka)

## 🎯 Patterns implémentés

### **API Gateway Pattern**
Un point d'entrée unique qui :
- Route les requêtes vers les bons services
- Gère l'authentification de manière centralisée
- Ajoute des headers pour les services downstream

### **Database per Service**
Chaque service a sa propre base de données :
- Isolation complète des données
- Scalabilité indépendante
- Pas de couplage via la base de données

### **Service Discovery**
Les services se trouvent via les noms DNS Docker :
- `auth-service`, `projects-service`, `tasks-service`
- Pas d'IPs hardcodées

### **Health Checks**
Chaque base de données a un health check :
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 10s
  timeout: 5s
  retries: 5
```


## 👤 Auteur

**Giresse Ayefou**
- GitHub: [@giresse21](https://github.com/giresse21)
- LinkedIn: [Giresse Ayefou](https://www.linkedin.com/in/giresse-ayefou)

## 📄 Licence

MIT License

---

⭐ **Si ce projet vous a été utile, n'hésitez pas à lui donner une étoile !**