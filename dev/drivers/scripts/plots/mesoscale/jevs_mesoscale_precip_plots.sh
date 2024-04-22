#PBS -N jevs_mesoscale_precip_plots
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=8:00:00
#PBS -l place=vscatter:exclhost,select=48:ncpus=128:mem=400GB
#PBS -l debug=true
#PBS -V

set -x
export model=evs
export machine=WCOSS2

# ECF Settings
export SENDECF=YES
export SENDCOM=YES
export KEEPDATA=YES
export SENDDBN=NO
export SENDDBN_NTC=
export SENDMAIL=NO
export job=${PBS_JOBNAME:-jevs_mesoscale_precip_plots}
export jobid=$job.${PBS_JOBID:-$$}
export SITE=$(cat /etc/cluster_name)
export USE_CFP=YES
export nproc=128
export evs_run_mode="production"

# General Verification Settings
export envir=prod
export NET="evs"
export STEP="plots"
export COMPONENT="mesoscale"
export RUN="atmos"
export VERIF_CASE="precip"
export MODELNAME=${COMPONENT}

# EVS Settings
export testfld=/lfs/h2/emc/vpppg/noscrub/roshan.shrestha/zz
# export testfld=/lfs/h2/emc/vpppg/save/roshan.shrestha
export HOMEevs=${testfld}/EVS
#export HOMEevs="/lfs/h2/emc/vpppg/noscrub/${USER}/EVS"
export HOMEevs=${HOMEevs:-${PACKAGEROOT}/evs.${evs_ver}}
export config=$HOMEevs/parm/evs_config/mesoscale/config.evs.prod.${STEP}.${COMPONENT}.${RUN}.${VERIF_CASE}

# Load Modules
source $HOMEevs/versions/run.ver
module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/dev/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh
export PYTHONPATH=$HOMEevs/ush/$COMPONENT:$PYTHONPATH
export evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

# Developer Settings
#export COMIN=/lfs/h2/emc/vpppg/noscrub/${USER}/$NET/$evs_ver_2d
export COMIN=/lfs/h2/emc/vpppg/noscrub/emc.vpppg/$NET/$evs_ver_2d
#export DATAROOT=/lfs/h2/emc/ptmp/${USER}/evs_test/$envir/tmp
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp
#export COMOUT=/lfs/h2/emc/ptmp/${USER}/$NET/$evs_ver_2d/$STEP/$COMPONENT
export COMOUT=/lfs/h2/emc/ptmp/${USER}/$NET/$evs_ver_2d/$STEP/$COMPONENT/rrfs
export vhr=${vhr:-${vhr}}

# Job Settings and Run
. ${HOMEevs}/jobs/JEVS_MESOSCALE_PLOTS
