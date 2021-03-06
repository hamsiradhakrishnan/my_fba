#!/bin/bash
source `which my_do_cmd`
echo "Running on `hostname`"

if [ "$#" -lt 1 ]
then
  echo "  [ERROR]. Insufficient arguments."
  echo "  Usage: `basename $0` subj"
  echo ""
  echo "  This script is part of the set of scripts required for fixel-based analyses."
  echo "  See my_fba.sh for help."
  exit 2
fi


subj=$1




# Here we reorient the direction of all fixels based on the Jacobian matrix (local affine transformation) at each voxel in the warp:


fd_std_noReorient=${FBA_DIR}/${subj}/fd_templateSpace_noReorient.msf
warp_subj2template=${FBA_DIR}/${subj}/fod_subj2template_warp.mif
fd_std_reorient=${FBA_DIR}/${subj}/fd_templateSpace_reorient.msf


isOK=1
for f in $fd_std_noReorient $warp_subj2template
do
  if [ ! -f $f ]
  then
    echo "  [ERROR] Cannot find file: $f"
    isOK=0
  fi
done
if [ $isOK -eq 0 ]
then
  echo "  [ERROR] Cannot perform fixel reorientation. Quitting."
  exit 2
fi


echo "  [INFO] Performing fixel reorientaion"
my_do_cmd fixelreorient \
  $fd_std_noReorient \
  $warp_subj2template \
  $fd_std_reorient