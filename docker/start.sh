docker run -it --rm \
 -v /Users/kyleneil/code:/root/ \
 -v /Users/kyleneil:/mnt \
 -v /Users/kyleneil/.bashrc:/root/.bashrc \
 --cap-add=SYS_PTRACE \
 --name base$1 base bash

