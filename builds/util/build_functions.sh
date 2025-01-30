
# Source this file using '.'

########################################
function capture_version {
   echo ""
   echo "Capture Version"
   VERSION_FUNC="${HOME_DIR}/../../grbsrc/ODBCAPTURE/ODBCAPTURE_VERSION.func"
   BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD 2>&1)"
   if [ "$?" != 0 ]
   then
      BRANCH_NAME='No Branch Name'
   fi
   VERSION_ABBR="${BRANCH_NAME:0:20}"
   # 'Branch main at f2c736d0cc6fd80d961414dcae37df2bed0d69e2 - https://github.com/DMSTEX/DMSTEX.git'
   VERSION_NOTE="Branch ${BRANCH_NAME} at $(git rev-parse HEAD 2>&1)" &&
   VERSION_NOTE="${VERSION_NOTE} - $(git config --get remote.origin.url 2>&1)"
   if [ $? = 0 ]
   then
      echo "${VERSION_NOTE}" > "${HOME_DIR}/version.txt"
   else
      echo "${VERSION_ABBR}" > "${HOME_DIR}/version.txt"
   fi
   sed -i "1,\$s/^   return ['].*['][;]\$/   return '${VERSION_ABBR}';/1" "${VERSION_FUNC}"
   }

########################################
function build_init {
   echo ""
   echo "build_initialize.sql"
   sqlplus "${SYS_LOGIN}" "@build_initialize.sql" "${PDB_NAME}"
   retcd="${?}"
   if [ "${retcd}" != "0" ]
   then
      echo "SQL*Plus returned ${retcd}.  Aborting"
      exit "${retcd}"
   fi
   }

########################################
function clear_log_files {
   BUILD_TYPE="${1}"
   echo ""
   echo "Clear old ${BUILD_TYPE} logs"
   rm -f "${BUILD_TYPE}"/*.xml
   rm -f "${BUILD_TYPE}"/*.log
   rm -f "${BUILD_TYPE}"/*.bad
   rm -f "${BUILD_TYPE}"/*.dsc
   rm -f "${BUILD_TYPE}"/*/*.log
   rm -f "${BUILD_TYPE}"/*/*.bad
   rm -f "${BUILD_TYPE}"/*/*.dsc
   }

########################################
function run_build {
   BUILD_TYPE="${1}"
   echo ""
   echo "Move to ${HOME_DIR}/../../${BUILD_TYPE}"
   cd "${HOME_DIR}/../../${BUILD_TYPE}"
   echo ""
   echo "${BUTIL_PATH}/run_build.sql ${BUILD_TYPE}"
   sqlplus "${PDB_SYS}" "@${BUTIL_PATH}/run_build.sql" "${PDB_SYSTEM}" "${USR_PASS}"
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
function run_script {
   BUILD_TYPE="${1}"
   SCRIPT_NAME="${2}"
   DB_CONNECTION="${3}"
   echo ""
   echo "Move to ${HOME_DIR}/../../${BUILD_TYPE}"
   cd "${HOME_DIR}/../../${BUILD_TYPE}"
   echo ""
   echo "${BUTIL_PATH}/run_script.sql ${BUILD_TYPE} ${SCRIPT_NAME}"
   sqlplus "${DB_CONNECTION}" "@${BUTIL_PATH}/run_script.sql" "${SCRIPT_NAME}"
   echo ""
   echo "Move back to ${HOME_DIR}"
   cd "${HOME_DIR}"
   }

########################################
function run_report {
   BUILD_TYPE="${1}"
   DB_CONNECTION="${2}"
   echo ""
   echo "Move to ${HOME_DIR}/../../${BUILD_TYPE}"
   cd "${HOME_DIR}/../../${BUILD_TYPE}"
   echo ""
   echo "report_status.sql ${BUILD_TYPE}"
   echo "exit" | sqlplus "${DB_CONNECTION}" "@report_status.sql" "${DB_CONNECTION}"
   echo ""
   echo "Move back to ${HOME_DIR}"
   cd "${HOME_DIR}"
   }

########################################
function move_log_files {
   BUILD_TYPE="${1}"
   echo ""
   echo "Move Log Files to Build Folder"
   echo "Move to ${HOME_DIR}/../../${BUILD_TYPE}"
   cd "${HOME_DIR}/../../${BUILD_TYPE}"
   mkdir -p "${HOME_DIR}/${BUILD_TYPE}" 2> /dev/null
   ls *.xml *.log *.bad *.dsc 2>/dev/null |
      while read FILE
      do
         mv -v "${FILE}" "${HOME_DIR}/${BUILD_TYPE}"
      done
   ls -F | grep '.*/$' |
      while read DIR
      do
         mkdir -p "${HOME_DIR}/${BUILD_TYPE}/${DIR}" 2> /dev/null
         ls "${DIR}"*.log "${DIR}"*.bad "${DIR}"*.dsc 2> /dev/null |
            while read FILE
            do
               mv -v "${FILE}" "${HOME_DIR}/${BUILD_TYPE}/${DIR}"
            done
       done
   echo ""
   echo "Move back to ${HOME_DIR}"
   cd "${HOME_DIR}"
   }
