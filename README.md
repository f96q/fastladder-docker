## Setup

```
cp .env.app.example .env.app
cp .env.db.example .env.db
docker-compose up
docker-compose run app rake db:migrate
```