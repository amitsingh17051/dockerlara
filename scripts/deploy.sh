#!/bin/bash

# Deployment script for Laravel Docker application
# Usage: ./scripts/deploy.sh [staging|production]

set -e

ENVIRONMENT=${1:-staging}
DOCKER_IMAGE="ghcr.io/your-username/your-repo"

echo "🚀 Starting deployment to $ENVIRONMENT environment..."

# Check if environment is valid
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    echo "❌ Invalid environment. Use 'staging' or 'production'"
    exit 1
fi

# Set environment-specific variables
if [[ "$ENVIRONMENT" == "staging" ]]; then
    COMPOSE_FILE="docker-compose.staging.yml"
    ENV_FILE="env.staging"
    PORT="8003"
else
    COMPOSE_FILE="docker-compose.production.yml"
    ENV_FILE="env.production"
    PORT="8004"
fi

echo "📦 Pulling latest Docker image..."
docker pull $DOCKER_IMAGE:$ENVIRONMENT

echo "🛑 Stopping existing containers..."
docker-compose -f $COMPOSE_FILE down

echo "🔄 Starting new containers..."
DOCKER_IMAGE=$DOCKER_IMAGE docker-compose -f $COMPOSE_FILE up -d

echo "⏳ Waiting for services to be ready..."
sleep 30

echo "🔧 Running Laravel setup commands..."
docker-compose -f $COMPOSE_FILE exec -T app php artisan migrate --force
docker-compose -f $COMPOSE_FILE exec -T app php artisan config:cache
docker-compose -f $COMPOSE_FILE exec -T app php artisan route:cache
docker-compose -f $COMPOSE_FILE exec -T app php artisan view:cache

echo "🧹 Cleaning up old images..."
docker image prune -f

echo "✅ Deployment to $ENVIRONMENT completed successfully!"
echo "🌐 Application is available at: http://localhost:$PORT"

