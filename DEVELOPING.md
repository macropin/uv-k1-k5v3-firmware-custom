# Developing with Docker

This document outlines how to use the provided `Makefile` and Docker environment to build the firmware, ensuring a consistent and isolated development setup.

## Prerequisites

Before you begin, ensure you have the following installed:

* **Docker**: Docker Desktop (or equivalent) must be installed and running on your system.

## 1. Building the Docker Image

The first step is to build the Docker image that serves as your development environment. This image contains all the necessary tools and dependencies (e.g., ARM GNU Toolchain, CMake, Git).

To build the image, run:

```bash
make docker-build
```

This command will execute `docker build -t uvk1-uvk5v3 .` and create an image named `uvk1-uvk5v3`. You only need to run this command when the `Dockerfile` changes or if you want to force a rebuild.

## 2. Building the Firmware

The `compile-with-docker.sh` script, invoked by the `make compile` command, orchestrates the build process within the Docker container. It handles cleaning the build directory, configuring CMake, and compiling the firmware.

To compile the firmware for the default preset (Custom), run:

```bash
make compile
```

You can also pass a specific preset to the `compile` target, for example:

```bash
make compile PRESET=Fusion
```

For more advanced CMake configurations or specific build steps, you can use the `docker-run` target described below.

## 3. Running Arbitrary Commands in the Docker Environment

The `docker-run` target allows you to execute any shell command directly within the configured Docker build environment. This is useful for running specific CMake commands, linting tools, or custom scripts that require the build environment's tools.

To run a command, use:

```bash
make docker-run CMD="<your-command-here>"
```

**Example: Configure CMake for a specific preset**

```bash
make docker-run CMD="cmake --preset Custom"
```

**Example: Build the project after configuration**

```bash
make docker-run CMD="cmake --build --preset Custom -j"
```

**Example: Check the dynamically generated version string (VERSION_STRING_2)**

```bash
make docker-run CMD="grep VERSION_STRING_2 build/Custom/CMakeCache.txt"
```

## 4. Getting an Interactive Shell in the Docker Environment

For debugging or interactive tasks, you can open a shell directly inside the Docker build container. This gives you full access to the environment's tools and files.

To get a shell, run:

```bash
make docker-shell
```

You will be dropped into a `bash` shell where you can execute commands as if you were inside the container. Type `exit` to leave the shell.

## 5. Dynamic Versioning with Git

The firmware's `VERSION_STRING_2` is automatically generated based on your Git repository's state.

* If the current commit has an exact Git tag (e.g., `v1.2.3`), that tag will be used as `VERSION_STRING_2`.
* Otherwise, the short Git commit hash of the current commit will be used.

This ensures that your firmware builds are always versioned according to your source control.

**Note on Git within Docker**: The Docker environment is configured to handle Git operations correctly within the mounted project directory (`/src`). This includes setting `HOME=/tmp` and adding `/src` to Git's safe directories to avoid "dubious ownership" errors.
