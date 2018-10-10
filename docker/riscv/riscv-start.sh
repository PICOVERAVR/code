docker run -it --rm \
 -v /Users/kyleneil/code:/root/host \
 -v /Users/kyleneil:/mnt \
 -v /Users/kyleneil/code/main/docker/docker_bashrc:/root/.bashrc \
 --cap-add=SYS_PTRACE \
 --name riscv_base$1 riscv-base bash

