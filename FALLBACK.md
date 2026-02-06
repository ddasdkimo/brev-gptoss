# Fallback: if native model fails on L40S

## Problem
gpt-oss-120b uses MXFP4 quantization natively.
MXFP4 compute kernels require SM 9.0+ (Hopper/Blackwell).
L40S is SM 8.9 (Ada Lovelace) — may fail.

## Fallback Option 1: Community GPTQ/AWQ version
Change docker-compose.yml command to:

```yaml
command: >
  vllm serve <GPTQ_MODEL_ID>
  --tensor-parallel-size 4
  --pipeline-parallel-size 2
  --quantization gptq
  --gpu-memory-utilization 0.92
  --max-model-len 32768
  --served-model-name gpt-oss
  --host 0.0.0.0
  --port 8000
```

Check HuggingFace for community GPTQ/AWQ versions:
- Search: "gpt-oss-120b GPTQ"
- Search: "gpt-oss-120b AWQ"

## Fallback Option 2: Force dtype override
Try adding `--dtype bfloat16` to let vLLM dequantize mxfp4 to bf16:

```yaml
command: >
  vllm serve openai/gpt-oss-120b
  --tensor-parallel-size 4
  --pipeline-parallel-size 2
  --dtype bfloat16
  --gpu-memory-utilization 0.92
  --max-model-len 32768
  --served-model-name gpt-oss
  --host 0.0.0.0
  --port 8000
```

Note: bf16 will use more VRAM (~234GB) but 8x L40S has 384GB total.

## Fallback Option 3: Reduce context if OOM
```yaml
--gpu-memory-utilization 0.88
--max-model-len 16384
```
