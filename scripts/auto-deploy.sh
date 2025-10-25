#!/bin/bash

# Auto-Deployment Script for Laravel Docker App
# This script automatically updates your Docker container with the latest image

set -e

echo "🚀 Starting auto-deployment..."

# Configuration
IMAGE_NAME="ghcr.io/amitsingh17051/dockerlara:latest"
CONTAINER_NAME="laravel_app"
COMPOSE_FILE="docker-compose.yml"

# Pull latest image
echo "📦 Pulling latest Docker image..."
docker pull $IMAGE_NAME

# Stop current container
echo "⏹️ Stopping current container..."
docker compose -f $COMPOSE_FILE stop app

# Remove old container
echo "🗑️ Removing old container..."
docker compose -f $COMPOSE_FILE rm -f app

# Update docker-compose.yml to use the new image
echo "🔄 Updating docker-compose.yml..."
sed -i "s|build:|# build:|g" $COMPOSE_FILE
sed -i "s|# image:|image:|g" $COMPOSE_FILE
sed -i "s|image: laravel-app:latest|image: $IMAGE_NAME|g" $COMPOSE_FILE

# Start new container
echo "▶️ Starting new container..."
docker compose -f $COMPOSE_FILE up -d app

# Wait for container to be ready
echo "⏳ Waiting for container to be ready..."
sleep 10

# Check if container is running
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Auto-deployment completed successfully!"
    echo "🌐 Your changes are now live at http://localhost:8002"
    
    # Test the deployment
    echo "🧪 Testing deployment..."
    if curl -s http://localhost:8002/test-cicd > /dev/null; then
        echo "✅ Deployment test passed!"
    else
        echo "⚠️ Deployment test failed, but container is running"
    fi
else
    echo "❌ Auto-deployment failed!"
    exit 1
fi

echo "🎉 Auto-deployment process completed!"
