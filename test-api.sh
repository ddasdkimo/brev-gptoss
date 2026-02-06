#!/bin/bash
# Test the vLLM API endpoint

echo "=== Testing vLLM API ==="

# 1. Check if server is up
echo ""
echo "[1] Health check - list models:"
curl -s http://localhost:8000/v1/models | python3 -m json.tool 2>/dev/null || echo "Server not ready yet"

# 2. Chat completion test
echo ""
echo "[2] Chat completion test:"
curl -s http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-oss",
    "messages": [
      {"role": "user", "content": "Hello, respond in one sentence."}
    ],
    "max_tokens": 100
  }' | python3 -m json.tool 2>/dev/null || echo "Chat completion failed"

echo ""
echo "=== Done ==="
