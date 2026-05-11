#!/bin/bash

echo "Attente des services Docker..."

for i in {1..30}
do
  echo "Tentative $i/30"

  docker compose ps

  MYSQL_STATUS=$(docker inspect --format='{{.State.Health.Status}}' mongo-api-mysql-db_mysql-1 2>/dev/null || echo "not_found")
  MONGO_STATUS=$(docker inspect --format='{{.State.Health.Status}}' mongo-api-mysql-db_mongo-1 2>/dev/null || echo "not_found")
  API_STATUS=$(docker inspect --format='{{.State.Health.Status}}' mongo-api-mysql-api-1 2>/dev/null || echo "not_found")

  echo "MySQL: $MYSQL_STATUS"
  echo "Mongo: $MONGO_STATUS"
  echo "API: $API_STATUS"

  if [ "$MYSQL_STATUS" = "healthy" ] && [ "$MONGO_STATUS" = "healthy" ] && [ "$API_STATUS" = "healthy" ]; then
    echo "Tous les services avec healthcheck sont healthy"
    exit 0
  fi

  sleep 10
done

echo "Erreur : les services ne sont pas devenus healthy à temps"
docker compose ps
docker compose logs db_mysql
docker compose logs db_mongo
docker compose logs api
exit 1