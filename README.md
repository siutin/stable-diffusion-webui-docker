# Stable Diffusion Webui Docker Image

### Build custom image

```
docker build --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')  --build-arg BUILD_VERSION=latest -t siutin/stable-diffusion-webui-docker .
```

### Run with cpu only
```
docker run -it --name sdw --network host \
  -v $(pwd)/models:/app/stable-diffusion-webui/models \
  -v $(pwd)/outputs:/app/stable-diffusion-webui/outputs \
  --rm siutin/stable-diffusion-webui-docker \
  bash webui.sh --skip-torch-cuda-test --precision full --no-half --use-cpu SD GFPGAN BSRGAN ESRGAN SCUNet --all --share
```
