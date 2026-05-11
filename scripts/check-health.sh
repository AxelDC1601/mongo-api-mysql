#!/bin/bash

echo "Attente des services healthy..."

for i in {1..30}
do
  echo "Tentative $i/30"
  docker compose ps

  if docker compose ps | grep -q "unhealthy"; then
    echo "Erreur : un service est unhealthy"
    docker compose logs
    exit 1
  fi

  if docker compose ps | grep -q "starting"; then
    echo "Des services sont encore en démarrage..."
    sleep 10
  else
    echo "Tous les services ne sont plus en starting"
    break
  fi
done


echo "Vérification finale :"
docker compose ps

if docker compose ps | grep -q "unhealthy"; then
  echo "Erreur finale : un service est unhealthy"
  docker compose logs
  exit 1
fi

echo "Tout est OK"