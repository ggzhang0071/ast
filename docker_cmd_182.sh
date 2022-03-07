#docker_cmd_93.sh
img="pytorch/pytorch:1.8.1-cuda11.1-cudnn8-devel"
#nvcr.io/nvidia/pytorch:18.01-py3



docker run --gpus all  --privileged=true   --workdir /git --name "ast"  -e DISPLAY --ipc=host -d --rm  -p 6624:4452  \
-v /raid/git/ast:/git/ast \
 -v  /raid/git/datasets:/git/datasets \
 $img sleep infinity


docker exec -it ast   /bin/bash
