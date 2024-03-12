#PBS -N jevs_mesoscale_precip_plots_rrfs
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=04:00:00
#PBS -l place=vscatter:exclhost,select=12:ncpus=128:mem=150GB
#PBS -l debug=true
#PBS -V

###PBS -l place=vscatter:exclhost,select=4:ncpus=128

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
export HOMEevs=${HOMEevs:-${PACKAGEROOT}/evs.${evs_ver}}
export config=$HOMEevs/parm/evs_config/mesoscale/config.evs.prod.${STEP}.${COMPONENT}.${RUN}.${VERIF_CASE}

# Load Modules
source $HOMEevs/versions/run.ver
module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/dev/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh
evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)
export PYTHONPATH=$HOMEevs/ush/$COMPONENT:$PYTHONPATH

# Developer Settings
export COMIN=/lfs/h2/emc/vpppg/noscrub/emc.vpppg/$NET/$evs_ver_2d
export COMINrrfs=/lfs/h2/emc/vpppg/noscrub/marcel.caron/${NET}_rrfs_v0.7.9/$evs_ver_2d
export EVSINrrfs=/lfs/h2/emc/vpppg/noscrub/marcel.caron/$NET/$evs_ver_2d/stats/cam

export DATAROOT=/lfs/h2/emc/ptmp/${USER}/evs_test/$envir/tmp
export COMOUT=/lfs/h2/emc/ptmp/${USER}/$NET/$evs_ver_2d/$STEP/$COMPONENT
export vhr=${vhr:-${vhr}}

# Job Settings and Run
. ${HOMEevs}/jobs/JEVS_MESOSCALE_PLOTS
