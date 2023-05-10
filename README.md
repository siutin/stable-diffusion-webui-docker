# Stable Diffusion Webui Docker Image

### Build custom image

```
docker buildx build --platform linux/amd64 --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')  --build-arg BUILD_VERSION=custom -t siutin/stable-diffusion-webui-docker:custom .
```

### Run with cpu only
```
docker run -it --name sdw --network host \
  -v $(pwd)/models:/app/stable-diffusion-webui/models \
  -v $(pwd)/outputs:/app/stable-diffusion-webui/outputs \
  --rm siutin/stable-diffusion-webui-docker \
  bash webui.sh --skip-torch-cuda-test --precision full --no-half --use-cpu all SD GFPGAN BSRGAN ESRGAN SCUNet --share
```
