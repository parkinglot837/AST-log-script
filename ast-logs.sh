#!/bin/bash

# Partial container name patterns
PARTIAL_NAMES=("otel" "prometheus" "grafana")

# Output directory for logs
OUTPUT_DIR="./docker_logs_$(date +%F)"
mkdir -p "$OUTPUT_DIR"

# Loop through each partial name pattern
for PARTIAL in "${PARTIAL_NAMES[@]}"; do
  # Find matching containers by name
  MATCHES=$(docker ps -a --format '{{.Names}}' | grep "$PARTIAL")

  if [ -z "$MATCHES" ]; then
    echo "No containers found matching: $PARTIAL"
    continue
  fi

  for CONTAINER_NAME in $MATCHES; do
    LOG_FILE="${OUTPUT_DIR}/${CONTAINER_NAME}.log"
    echo "Saving logs for container: $CONTAINER_NAME"
    docker logs "$CONTAINER_NAME" &> "$LOG_FILE"
  done
done

echo "Done. Logs saved in $OUTPUT_DIR"
