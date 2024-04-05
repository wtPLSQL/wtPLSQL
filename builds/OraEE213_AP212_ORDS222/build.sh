#!/bin/bash

#
# Build Script for
#  -) Oracle Enterprise Edition 21.3
#  -) Application Express 21.2
#  -) Oracle REST Data Services 22.2
#
# Command Line Parameters
#  -) 1 - PDB Password
#  -) 2 - Version
#

# Copy stderr and stdout to log file
exec &> >(tee build.log)

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
PDB_PASS="${1}"
VERSION="${2}"
CDB_SYS="SYS/${PDB_PASS}@//${HOST_NAME_PORT}/${CDB_NAME} as sysdba"
PDB_SYS="SYS/${PDB_PASS}@//${HOST_NAME_PORT}/${PDB_NAME} as sysdba"
PDB_SYSTEM="SYSTEM/${PDB_PASS}@//${HOST_NAME_PORT}/${PDB_NAME}"
PDB_WTP="WTP/WTP@//${HOST_NAME_PORT}/${PDB_NAME}"
###
echo ""
echo "Capture Version"
# 'https://github.com/DMSTEX/DMSTEX.git at f2c736d0cc6fd80d961414dcae37df2bed0d69e2 (Branch: main)'
VERSION_NOTE="$(git config --get remote.origin.url 2>&1)" &&
VERSION_NOTE="${VERSION_NOTE} at $(git rev-parse HEAD 2>&1)" &&
VERSION_NOTE="${VERSION_NOTE} (Branch: $(git rev-parse --abbrev-ref HEAD 2>&1))"
if [ $? = 0 ]
then
   echo "${VERSION_NOTE}" > "version.txt"
else
   echo "${VERSION}" > "version.txt"
fi

########################################
# Initialize the build
echo ""
echo "build_initialize.sql"
sqlplus /nolog "@build_initialize.sql" "${PDB_NAME}" "${CDB_SYS}"
retcd="${?}"
if [ "${retcd}" != "0" ]
then
   echo "SQL*Plus returned ${retcd}.  Aborting"
   exit "${retcd}"
fi

########################################
function clear_log_files {
   echo ""
   echo "Clear old ${INSTALL_TYPE} logs"
   rm -f "${INSTALL_TYPE}"/*.xml
   rm -f "${INSTALL_TYPE}"/*.log
   rm -f "${INSTALL_TYPE}"/*.bad
   rm -f "${INSTALL_TYPE}"/*.dsc
   rm -f "${INSTALL_TYPE}"/*/*.log
   rm -f "${INSTALL_TYPE}"/*/*.bad
   rm -f "${INSTALL_TYPE}"/*/*.dsc
   }

########################################
function move_log_files {
   echo ""
   echo "Move Log Files to Build Folder"
   mkdir -p "${BUILD_PATH}/${INSTALL_TYPE}" 2> /dev/null
   ls *.xml *.log *.bad *.dsc 2>/dev/null |
      while read FILE
      do
         mv -v "${FILE}" "${BUILD_PATH}/${INSTALL_TYPE}"
      done
   ls -F | grep '.*/$' |
      while read DIR
      do
         mkdir -p "${BUILD_PATH}/${INSTALL_TYPE}/${DIR}" 2> /dev/null
         ls "${DIR}"*.log "${DIR}"*.bad "${DIR}"*.dsc 2> /dev/null |
            while read FILE
            do
               mv -v "${FILE}" "${BUILD_PATH}/${INSTALL_TYPE}/${DIR}"
            done
       done
   }

########################################
function run_build {
   INSTALL_TYPE="${1}"
   clear_log_files
   echo ""
   echo "Move to ../../${INSTALL_TYPE}"
   cd "../../${INSTALL_TYPE}"
   echo ""
   echo "${BUILD_PATH}/build.sql ${INSTALL_TYPE}"
   sqlplus /nolog "@${BUILD_PATH}/build.sql" "${BUTIL_PATH}" "${PDB_SYS}" "${PDB_SYSTEM}" "${INSTALL_TYPE}" "${VERSION}"
   retcd="${?}"
   if [ "${retcd}" != "0" ]
   then
      echo "SQL*Plus returned ${retcd}.  Aborting"
      exit "${retcd}"
   fi
   move_log_files
   echo ""
   echo "Move back to ${HOME_DIR}"
   cd "${HOME_DIR}"
   }

########################################
function setup_for_test {
   echo ""
   echo "Running ../util/setup_for_test.sql from ${PWD}"
   sqlplus "${PDB_SYSTEM}" "@../util/setup_for_test.sql"
   }

########################################
function run_core_test {
   echo ""
   echo "Running ../util/run_core_test.sql from ${PWD}"
   sqlplus "${PDB_WTP}" "@../util/run_core_test.sql"
   }

########################################
function run_junit_test {
   echo ""
   echo "Running ../util/run_junit_test.sql from ${PWD}"
   sqlplus "${PDB_WTP}" "@../util/run_junit_test.sql"
   }

########################################
function run_save_test {
   echo ""
   echo "Running ../util/run_save_test.sql from ${PWD}"
   sqlplus "${PDB_WTP}" "@../util/run_save_test.sql"
   }

########################################
run_build 'wtpsrc'
run_build 'wtptst'
run_build 'wtpsav'
setup_for_test
run_core_test
run_junit_test
run_save_test
run_build 'grbsrc'
run_build 'wtpgrb'
