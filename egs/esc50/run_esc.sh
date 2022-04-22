#!/bin/bash
#SBATCH -p gpu
#SBATCH -x sls-titan-[0-2]
#SBATCH --gres=gpu:4
#SBATCH -c 4
#SBATCH -n 1
#SBATCH --mem=48000
#SBATCH --job-name="ast-esc50"
#SBATCH --output=./log_%j.txt

export TORCH_HOME=/git/ast/pretrained_models


model=ast
dataset=esc50
imagenetpretrain=True
audiosetpretrain=True
bal=none
if [ $audiosetpretrain == True ]
then
  lr=1e-5
else
  lr=1e-4
fi
freqm=24
timem=96
mixup=0
epoch=25
batch_size=48
fstride=10
tstride=10
base_exp_dir=./exp/test-${dataset}-f$fstride-t$tstride-imp$imagenetpretrain-asp$audiosetpretrain-b$batch_size-lr${lr}
python ./prep_esc50.py




for((fold=1;fold<=5;fold++));
do
  echo 'now process fold'${fold}

  exp_dir=${base_exp_dir}/fold${fold}

  tr_data=/git/ast/egs/esc50/data/datafiles/esc_train_data_${fold}.json
  te_data=/git/ast/egs/esc50/data/datafiles/esc_eval_data_${fold}.json

  CUDA_CACHE_DISABLE=1  python  -W ignore -m  pdb  ../../src/run.py --model ${model} --dataset ${dataset} \
  --data-train ${tr_data} --data-val ${te_data} --exp-dir $exp_dir \
  --label-csv ./data/esc_class_labels_indices.csv --n_class 50 \
  --lr $lr --n-epochs ${epoch} --batch-size $batch_size --save_model False \
  --freqm $freqm --timem $timem --mixup ${mixup} --bal ${bal} \
  --tstride $tstride --fstride $fstride --imagenet_pretrain $imagenetpretrain --audioset_pretrain $audiosetpretrain 2>&1 | tee log_esc50.txt
done

#python ./get_esc_result.py --exp_path ${base_exp_dir}