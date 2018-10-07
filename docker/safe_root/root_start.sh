echo "WARNING: Running container with full privileges!"
docker create -it --rm --privileged --name root_base base bash

if [[ $# == 0 ]]; then
	echo "starting with no args!"
else 
	docker cp $1 root_base:/root/copy
fi

docker start -ai root_base

