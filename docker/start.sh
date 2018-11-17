docker run -it --rm \
 -v /Users/kyleneil/code:/root/ \
 -v /Users/kyleneil:/mnt \
 -v /Users/kyleneil/code/main/docker/docker_bashrc:/root/.bashrc \
 -v /Users/kyleneil/code/main/docker/docker_vimrc:/root/.vimrc \
 --cap-add=SYS_PTRACE \
 --security-opt seccomp=unconfined \
 --name base$1 base bash

