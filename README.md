# docker-evosc

This repository builds a Docker image for EvoSC. The container bundles a clean copy of EvoSC in `/opt/evosc` and seeds `/home/container` on first boot, so default configuration files are available even when the Pterodactyl volume mounts an empty directory.

## Publishing

Releases published on GitHub trigger the `Docker Publish` workflow, which builds the image and pushes it to `evotm/evosc`.
