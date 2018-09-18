docker run -it --rm -v /Users/kyleneil/code:/root/host -v /Users/kyleneil:/mnt --cap-add=SYS_PTRACE --name riscv-base$1 riscv-base bash
