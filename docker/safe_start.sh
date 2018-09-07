docker create -it --rm --cap-add=SYS_PTRACE --name safe_base base bash

if [[ $# != 1 ]]; then
	echo "starting with no args!"
else 
	docker cp $1 safe_base:/root/copy
fi

docker start -ai safe_base

