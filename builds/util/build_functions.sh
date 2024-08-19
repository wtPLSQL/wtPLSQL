
# Source this file using '.'

########################################
function capture_version {
   echo ""
   echo "Capture Version"
   # 'Branch main at f2c736d0cc6fd80d961414dcae37df2bed0d69e2 - https://github.com/DMSTEX/DMSTEX.git'
   VERSION_NOTE="Branch $(git rev-parse --abbrev-ref HEAD 2>&1))" &&
   VERSION_NOTE="${VERSION_NOTE} at $(git rev-parse HEAD 2>&1)" &&
   VERSION_NOTE="${VERSION_NOTE} - $(git config --get remote.origin.url 2>&1)"
   if [ $? = 0 ]
   then
      echo "${VERSION_NOTE}" > "version.txt"
   else
      echo "${VERSION}" > "version.txt"
   fi
   }

########################################
function build_init {
   echo ""
   echo "build_initialize.sql"
   sqlplus /nolog "@build_initialize.sql" "${PDB_NAME}" "${CDB_SYS}"
   retcd="${?}"
   if [ "${retcd}" != "0" ]
   then
      echo "SQL*Plus returned ${retcd}.  Aborting"
      exit "${retcd}"
   fi
   }

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
function run_build {
   INSTALL_TYPE="${1}"
   echo ""
   echo "Move to ../../${INSTALL_TYPE}"
   cd "../../${INSTALL_TYPE}"
   echo ""
   echo "${BUTIL_PATH}/build.sql ${INSTALL_TYPE}"
   sqlplus /nolog "@${BUTIL_PATH}/run_build.sql" "${BUTIL_PATH}" "${PDB_SYS}" "${PDB_SYSTEM}" "${USR_PASS}" "${INSTALL_TYPE}" "$(< version.txt)"
   retcd="${?}"
   if [ "${retcd}" != "0" ]
   then
      echo "SQL*Plus returned ${retcd}.  Aborting"
      exit "${retcd}"
   fi
   echo ""
   echo "Move back to ${HOME_DIR}"
   cd "${HOME_DIR}"
   }

########################################
function setup_for_test {
   echo ""
   echo "Running ../util/setup_for_test.sql from ${PWD}"
   sqlplus "${PDB_SYSTEM}" "@../util/setup_for_test.sql"
   # Unit Testing Expects NO DB Links
   #echo "Running ../util/setup_db_links.sql from ${PWD}"
   #sqlplus "${PDB_WTP}" "@../util/setup_db_links.sql"
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
function move_log_files {
   echo ""
   echo "Move Log Files to Build Folder"
   echo "Move to ../../${INSTALL_TYPE}"
   cd "../../${INSTALL_TYPE}"
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
   echo ""
   echo "Move back to ${HOME_DIR}"
   cd "${HOME_DIR}"
   }
