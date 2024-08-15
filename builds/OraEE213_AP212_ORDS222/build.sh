#!/bin/bash

#
# Build Script for
#  -) Oracle Enterprise Edition 21.3
#  -) Application Express 21.2
#  -) Oracle REST Data Services 22.2
#
# Command Line Parameters
#  -) 1 - SYS Password
#  -) 2 - User Password
#  -) 3 - Version
#

SYS_PASS="${1}"
USR_PASS="${2}"
VERSION="${3}"

# Copy stderr and stdout to log file
exec &> >(tee build.log)

########################################
# Confirm starting location
if ! ls "$(basename $0)"
then
   echo "This script must be run from its source location"
   exit -1
fi
HOME_DIR="${PWD}"
echo "Running from ${HOME_DIR}"

########################################
echo ""
echo "Setup Variables"
###
BUILD_PATH='../builds/OraEE213_AP212_ORDS222'
BUTIL_PATH='../builds/util'
IFILE_PATH='../../../install_files'
HOST_NAME_PORT='localhost:1521'
CDB_NAME='EE213CDB'
PDB_NAME='DEVPDB'
###
CDB_SYS="SYS/${SYS_PASS}@//${HOST_NAME_PORT}/${CDB_NAME} as sysdba"
PDB_SYS="SYS/${SYS_PASS}@//${HOST_NAME_PORT}/${PDB_NAME} as sysdba"
PDB_SYSTEM="SYSTEM/${SYS_PASS}@//${HOST_NAME_PORT}/${PDB_NAME}"
PDB_WTP="WTP/26${USR_PASS}@//${HOST_NAME_PORT}/${PDB_NAME}"

########################################
# Source the Build Functions
. ../util/build_functions.sh

########################################
clear_log_files
capture_version
build_init
run_build 'wtpsrc'
run_build 'wtptst'
run_build 'wtpsav'
setup_for_test
run_core_test
run_junit_test
run_save_test
run_build 'grbsrc'
run_build 'wtpgrb'
move_log_files
