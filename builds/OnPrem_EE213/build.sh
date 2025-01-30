#!/bin/bash

#
# Build Script for Oracle Enterprise Edition 21.3
#  -) Application Express 21.2
#  -) Oracle REST Data Services 22.2
#
# Command Line Parameters
#  -) 1 - SYS Password
#  -) 2 - User Password
#

SYS_PASS="${1}"
USR_PASS="${2}"

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
BUTIL_PATH="${HOME_DIR}/../util"
IFILE_PATH='../../../install_files'
PDB_NAME='DEVPDB'
###
#HOST_NAME_PORT='localhost:1521'
#SYS_LOGIN="SYS/${SYS_PASS}@//${HOST_NAME_PORT}/EE213CDB as sysdba"
SYS_LOGIN="SYS/${SYS_PASS}@OnPrem_EE213CDB as sysdba"
PDB_SYS="SYS/${SYS_PASS}@OnPrem_EE213_${PDB_NAME} as sysdba"
PDB_SYSTEM="SYSTEM/${SYS_PASS}@OnPrem_EE213_${PDB_NAME}"
PDB_WTP="WTP/WTP@OnPrem_EE213_${PDB_NAME}"

########################################
# Source the Build Functions
. ${BUTIL_PATH}/build_functions.sh

########################################
function build_type_build () {
   clear_log_files "${1}"
   run_build       "${1}"
   run_report      "${1}" "${2}"
   move_log_files  "${1}"
   }

########################################
# Initialize
capture_version
build_init
# Build Application
build_type_build 'wtpsrc' "${PDB_SYSTEM}"
build_type_build 'wtpsav' "${PDB_SYSTEM}"
build_type_build 'wtptst' "${PDB_SYSTEM}"
# Test Application
clear_log_files 'unit_testing'
run_script 'unit_testing' 'setup_for_test.sql' "${PDB_WTP}"
exit
#run_script 'unit_testing' 'setup_db_links' "${PDB_WTP}"  # Unit Testing Expects NO DB Links
run_script 'unit_testing' 'run_core_test.sql' "${PDB_WTP}"
run_script 'unit_testing' 'run_junit_test.sql' "${PDB_WTP}"
run_script 'unit_testing' 'run_save_test.sql' "${PDB_WTP}"
move_log_files 'unit_testing'
# Setup ODBCapture
#build_type_build 'wtp_gui' "${PDB_SYSTEM}"  # No APEX Availabe in OnPrem_EE213
build_type_build 'grbsrc' "${PDB_SYSTEM}"
build_type_build 'wtpgrb' "${PDB_SYSTEM}"
