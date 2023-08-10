# bash experiments/imagenet-r.sh
# experiment settings
SPLIT=10
DATASET=CIFAR100
N_CLASS=100

# save directory
DATE=ICCV
OUTDIR=_outputs/${DATE}/${DATASET}/${SPLIT}-task/AsyncFed-CPrompt

# hard coded inputs
GPUID='2 3 0 1'
# GPUID2='3 2 1 0'

#CONFIG_VIT=configs/imnet-r_vit.yaml
CONFIG_VIT_CODA=configs/cifar100.yaml
CONFIG_VIT_CODA_niid=configs/cifar100_niid.yaml

#CONFIG_VIT_P=configs/imnet-r_vit_prompt.yaml
REPEAT=1
MEMORY=0
OVERWRITE=1
DEBUG=0

###############################################################

# process inputs
if [ $DEBUG -eq 1 ] 
then   
    MAXTASK=3
    SCHEDULE="2"
fi
mkdir -p $OUTDIR

# NOTE - final results are found in _outputs/EXP_NAME/results-acc/global.yaml

# CODA-P
# 
# NOTE - coda-p is currently implemented within the "DualPrompt" class, with a different model file (see configs) and prompting inputs
POOL=100
LEN=8
MU_ORTHO=0.1
python -u run_async_clients.py --config $CONFIG_VIT_CODA --gpuid $GPUID --repeat $REPEAT --memory $MEMORY --overwrite $OVERWRITE --debug_mode $DEBUG \
    --learner_type prompt --learner_name DualPrompt \
    --prompt_param $POOL $LEN 0 0 0 --mu $MU_ORTHO --fedMoon 3\
    --log_dir ${OUTDIR}/vit/iid  --wandbgroup AsyncFed-CPrompt-iid



# python -u run_async_clients.py --config $CONFIG_VIT_CODA_niid --gpuid $GPUID2 --repeat $REPEAT --memory $MEMORY --overwrite $OVERWRITE --debug_mode $DEBUG \
#     --learner_type prompt --learner_name DualPrompt \
#     --prompt_param $POOL $LEN 0 0 0 --mu $MU_ORTHO --fedMoon 3\
#     --log_dir ${OUTDIR}/vit/cifarfed_pacing_niid_0_5_fm3 --wandbgroup cifar-Niid_pacing_0_5_fm_3

# DualPrompt
#
# NOTE - for implementation issues, set general prompt length to 6 instead of 5 so that it can be split into half for prefix tuning
#python -u run.py --config $CONFIG_VIT_P --gpuid $GPUID --repeat $REPEAT --memory $MEMORY --overwrite $OVERWRITE --debug_mode $DEBUG \
#    --learner_type prompt --learner_name DualPrompt \
#    --prompt_param 10 20 6 \
#    --log_dir ${OUTDIR}/vit/dual-prompt
