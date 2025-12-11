# docker-evosc

This repository builds a Docker image for EvoSC. A GitHub Actions workflow publishes the image to GitHub Container Registry (GHCR) under `ghcr.io/<owner>/docker-evosc` when pushing to `main` or tagging a release.

## Publishing

1. Push commits to the `main` branch or create a tag (for example `v1.0.0`).
2. GitHub Actions logs in to GHCR with the repository `GITHUB_TOKEN` and builds the image.
3. Images are pushed with tags for the branch, tag names, and the current commit SHA.

You can pull the latest image with:

```
docker pull ghcr.io/<owner>/docker-evosc:latest
```
