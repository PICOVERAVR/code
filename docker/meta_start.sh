# create a docker instance with the specified parameters
# ./meta_start.sh [ PORT MAP ]

# PORT MAP = 53022:22
 
if [ $# -ne 2 ];
then
	echo "defaulting to no ports"
	docker run -it --rm --cap-add=SYS_PTRACE meta_base bash
	exit 1;
fi

docker run -it --rm -p ${1:?"No port set."} --cap-add=SYS_PTRACE meta_base bash
