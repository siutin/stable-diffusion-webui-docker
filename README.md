# Stable Diffusion Webui Docker Image

### Compatibility and Breaking Changes

If you encounter issues that were not present before, please try switching to the following image versions:

```
siutin/stable-diffusion-webui-docker:latest-cuda-12.1.1
siutin/stable-diffusion-webui-docker:cuda-v1.10.1-2024-07-30
```

---

### Prepare the directory mapping in your host:
```
mkdir -p /MY-DATA-DIR && cd /MY-DATA-DIR
mkdir models outputs
sudo chown 10000:$UID -R models outputs
sudo chmod 775 -R models outputs
```

### Run with CUDA

```
# With the latest CUDA version
docker run -it --name sdw --gpus all --network host \
  -v $(pwd)/models:/app/stable-diffusion-webui/models \
  -v $(pwd)/outputs:/app/stable-diffusion-webui/outputs \
  --rm siutin/stable-diffusion-webui-docker:latest-cuda \
  bash webui.sh --share


# With specific CUDA version
docker run -it --name sdw --gpus all --network host \
  -v $(pwd)/models:/app/stable-diffusion-webui/models \
  -v $(pwd)/outputs:/app/stable-diffusion-webui/outputs \
  --rm siutin/stable-diffusion-webui-docker:latest-cuda-12.6.2 \
  bash webui.sh --share
```

### Run with CPU only
```
docker run -it --name sdw --network host \
  -v $(pwd)/models:/app/stable-diffusion-webui/models \
  -v $(pwd)/outputs:/app/stable-diffusion-webui/outputs \
  --rm siutin/stable-diffusion-webui-docker:latest-cpu \
  bash webui.sh --skip-torch-cuda-test --use-cpu all --share
```

### Build custom image

```
# Nvidia CUDA image
nvidia-docker buildx build -f Dockerfile.cuda \
                           --platform linux/amd64 \
                           --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
                           --build-arg BUILD_VERSION=custom-cuda \
                           -t siutin/stable-diffusion-webui-docker:custom-cuda .

# Nvidia CUDA image with specific version
nvidia-docker buildx build -f Dockerfile.cuda \
                           --platform linux/amd64 \
                           --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
                           --build-arg BUILD_VERSION=custom-cuda \
                           --build-arg CUDA_VERSION=12.5.1 \
                           -t siutin/stable-diffusion-webui-docker:custom-cuda-12.5 .

# CPU only image
docker buildx build -f Dockerfile.cpu \
                           --platform linux/arm64 \
                           --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
                           --build-arg BUILD_VERSION=custom-cpu \
                           -t siutin/stable-diffusion-webui-docker:custom-cpu .
```
### Enable API and remote access

```
# Enable API and Remote Access to the container for tools like Open-WebUI
just add 'bash webui.sh --api --listen' to the different images above
```

### Miscellaneous

```
# Check your current CUDA Driver API version
nvidia-smi -x -q |sed -n 's/.*<cuda_version>\(.*\)<\/cuda_version>.*/\1/p'
```
