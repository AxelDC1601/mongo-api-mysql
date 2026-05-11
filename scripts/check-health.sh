#!/bin/bash

echo "Vérification des containers..."

docker compose ps

if docker compose ps | grep -q "unhealthy"; then
  echo "Erreur : un service est unhealthy"
  docker compose logs
  exit 1
fi

if docker compose ps | grep -q "starting"; then
  echo "Erreur : un service est encore en démarrage"
  docker compose logs
  exit 1
fi

echo "Tous les services sont healthy"