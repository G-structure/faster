# Setup
```
apt-get update && apt-get -y install git git-lfs
git install lfs
git submodule update --init --recursive
mkdir -p ${HOME}/wagmi/compiled_models
sudo docker build -t faster .
```

# Start docker container
```
sudo docker run --rm --gpus all --entrypoint /bin/bash -it -v ${HOME}/wagmi/compiled_models:/compiled_models faster
```

**Run the following commands in the bash of the docker container**
## Build Models (only needs to be ran once)
```
python3 /app/TensorRT-LLM/examples/llama/convert_checkpoint.py --model_dir /app/Meta-Llama-3-8B --output_dir /compiled_models/llama3 --tp_size 1
trtllm-build --checkpoint_dir /compiled_models/llama3 \
    --gemm_plugin float16 \
    --output_dir /compiled_models/llama3-engine
```

## Inference 
```
python3 /app/TensorRT-LLM/examples/run.py --engine_dir /compiled_models/llama3-engine --max_output_len 100 --tokenizer_dir /app/Meta-Llama-3-8B --input_text "How do I count to nine in French?"
```

## Summary
```
python3 /app/TensorRT-LLM/examples/summarize.py --test_trt_llm \
                       --hf_model_dir /app/Meta-Llama-3-8B   \
                       --data_type fp16 \
                       --engine_dir /compiled_models/llama3-engine
```
