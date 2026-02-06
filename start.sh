#!/bin/bash
set -e

echo "========================================="
echo " GPT-OSS 120B vLLM on Brev (8x L40S)"
echo "========================================="

# Verify GPU availability
echo ""
echo "[1/4] Checking GPUs..."
nvidia-smi --query-gpu=index,name,memory.total --format=csv,noheader
GPU_COUNT=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
echo "  -> Found ${GPU_COUNT} GPUs"

if [ "$GPU_COUNT" -lt 8 ]; then
  echo "WARNING: Expected 8 GPUs but found ${GPU_COUNT}"
fi

# Check GPU topology (PCIe vs NVLink)
echo ""
echo "[2/4] GPU Topology:"
nvidia-smi topo -m

# Check Docker nvidia runtime
echo ""
echo "[3/4] Checking Docker nvidia runtime..."
if docker info 2>/dev/null | grep -q nvidia; then
  echo "  -> nvidia runtime OK"
else
  echo "  -> WARNING: nvidia runtime not detected in docker info"
  echo "     Trying with --gpus flag instead..."
fi

# Start vLLM
echo ""
echo "[4/4] Starting vLLM container..."
docker compose pull
docker compose up -d

echo ""
echo "========================================="
echo " Container started. Tailing logs..."
echo " API will be at: http://0.0.0.0:8000/v1"
echo " Model name:     gpt-oss"
echo ""
echo " First startup will take 10-30 min"
echo " (downloading model + loading weights)"
echo "========================================="
echo ""

docker compose logs -f
