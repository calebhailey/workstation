# Docker-based Development Environments

This is my Docker-based development environment. It keeps my workstation free of project cruft. 🧹

## General Usage

1. **Clone this repo**

   ```
   git clone https://github.com/calebhailey/workstation.git
   cd workstation
   ```

1. **Build the image**

   ```
   docker build -t calebhailey/workstation:latest .
   ```

   > _NOTE: optionally configure `--build USER=${USER}` and `--build-arg UID=${UID}` as needed. See [`Dockerfile`](/Dockerfile) for more information._

1. **Run the image** 

   ```
   docker run --rm -v ${HOME}:/home/me calebhailey/workstation:latest
   ```

   To execute `docker` commands from the Docker container, volume mount the Docker socket: 

   ```
   docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v ${HOME}:/home/me -it calebhailey/workstation:latest
   ```

   > _NOTE: the `--rm` flag will automatically clean up the workstation Docker image when it is stopped, and the `-v ${HOME}:/home/me` flag volume mounts your home directory, presumably containing all of your project files._

1. **For a good time, create an alias**

   To launch the workstation using the `workstation` alias, add the following line to your `.profile`, `.bashrc`, `.bash_aliases`, or similar dotfile: 

   ```
   alias workstation="docker run --rm -v ${HOME:/home/me} calebhailey/workstation:latest
   ```

## Project-based Usage

Using Docker as a development environment will help keep your workstation free from cruft, but it can get annoying to have to install dependencies on a per-project basis. 
To pre-install project dependencies on a per-project bases, just add a `Dockerfile` to the project root using this image (i.e. `FROM calebhailey/workstation:latest`)

For example, to create a reusable development environment for a [Hugo] website project:

1. Initialize a Dockerfile

   Add a `Dockerfile` with the following contents:

   ```
   # Hugo development environment Docker image
   FROM calebhailey/workstation:latest
   
   EXPOSE 1313/tcp
   ARG HUGO_VERSION=0.102.3
   
   # Install Hugo
   RUN \
     cd /tmp &&\
     curl -LO https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz &&\
     tar -xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz hugo &&\
     sudo mv hugo /usr/bin/ &&\
     hugo version &&\
     rm hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
   ```

1. Build custom development environment images

   ```
   docker build -t hugo-dev:latest .
   ```

   Don't forget the dot! 😅

1. Then run your custom development environment workstation: 

   ```
   docker run --rm -p 1313:1313 -v ${HOME}:/home/me -it hugo-dev:latest
   ```

[Hugo]: https://gohugo.io