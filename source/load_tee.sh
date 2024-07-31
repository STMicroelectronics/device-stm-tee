#!/bin/bash
#
# Load OP-TEE source

# Copyright (C)  2019. STMicroelectronics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#######################################
# Constants
#######################################
SCRIPT_VERSION="1.3"

SOC_FAMILY="stm32mp2"
SOC_NAME="stm32mp25"
SOC_VERSIONS=( "stm32mp257f" )

DEFAULT_TEE_VERSION=3.19.0

if [ -n "${ANDROID_BUILD_TOP+1}" ]; then
  TOP_PATH=${ANDROID_BUILD_TOP}
elif [ -d "device/stm/${SOC_FAMILY}-tee" ]; then
  TOP_PATH=$PWD
else
  echo "ERROR: ANDROID_BUILD_TOP env variable not defined, this script shall be executed on TOP directory"
  exit 1
fi

\pushd ${TOP_PATH} >/dev/null 2>&1

COMMON_PATH="${TOP_PATH}/device/stm/${SOC_FAMILY}"
TEE_PATH="${TOP_PATH}/device/stm/${SOC_FAMILY}-tee"

TEE_PATCH_PATH="${TEE_PATH}/source/patch"

TEE_OS_CONFIG_FILES=( "opteeos" )
TEE_USER_CONFIG_FILES=( "opteeuser" "kmgk" )

TEE_OS_CONFIG_STATUS_PATH="${COMMON_PATH}/configs/tee.config"
TEE_USER_CONFIG_STATUS_PATH="${COMMON_PATH}/configs/teeuser.config"

#######################################
# Variables
#######################################
nb_states=2
force_load=0
do_user_load=0
msg_patch=0

tee_version=${DEFAULT_TEE_VERSION}

#######################################
# Functions
#######################################

#######################################
# Add empty line in stdout
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
empty_line()
{
  echo
}

#######################################
# Print script usage on stdout
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
usage()
{
  echo "Usage: `basename $0` [Options]"
  empty_line
  echo "  This script allows loading the OP-TEE source"
  empty_line
  echo "Options:"
  echo "  -h/--help: print this message"
  echo "  -v/--version: get script version"
  echo "  -f/--force: force tee load"
  echo "  -u/--user: load userland TEE source based on configuration file ${TEE_USER_CONFIG_FILE} (default: ${TEE_OS_CONFIG_FILE})"
  empty_line
}

#######################################
# Print error message in red on stderr
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
error()
{
  echo "$(tput setaf 1)ERROR: $1$(tput sgr0)" >&2
}

#######################################
# Print warning message in orange on stdout
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
warning()
{
  echo "$(tput setaf 3)WARNING: $1$(tput sgr0)"
}

#######################################
# Print message in blue on stdout
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
blue()
{
  echo "$(tput setaf 6)$1$(tput sgr0)"
}

#######################################
# Print message in green on stdout
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
green()
{
  echo "$(tput setaf 2)$1$(tput sgr0)"
}

#######################################
# Clear current line in stdout
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
clear_line()
{
  echo -ne "\033[2K"
}

#######################################
# Print state message on stdout
# Globals:
#   I nb_states
#   I/O action_state
# Arguments:
#   None
# Returns:
#   None
#######################################
action_state=1
state()
{
  clear_line
  echo -ne "  [${action_state}/${nb_states}]: $1 \033[0K\r"
  action_state=$((action_state+1))
}

#######################################
# Clean before exit
# Globals:
#   I tee_path
#   I msg_patch
# Arguments:
#   $1: ERROR or OK
# Returns:
#   None
#######################################
teardown() {

  if [[ "$1" == "ERROR" ]]; then
      \pushd $TOP_PATH >/dev/null 2>&1
      \rm -rf ${tee_path}
      \popd >/dev/null 2>&1
  fi

  if [[ ${msg_patch} == 1 ]]; then
    \popd >/dev/null 2>&1
  fi

  # Come back to original directory
  \popd >/dev/null 2>&1
}

#######################################
# Check TEE status within the status file
# Globals:
#   I TEE_USER_CONFIG_STATUS_PATH
#   I TEE_OS_CONFIG_STATUS_PATH
#   I config_name
# Arguments:
#   None
# Returns:
#   1 if TEE is already loaded
#   0 if TEE is not already loaded
#######################################
check_tee_status()
{
  local tee_status
  local tee_config_status_path

  if [[ ${do_user_load} == 1 ]]; then
    tee_config_status_path=${TEE_USER_CONFIG_STATUS_PATH}
  else
    tee_config_status_path=${TEE_OS_CONFIG_STATUS_PATH}
  fi

  \ls ${tee_config_status_path}  >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    tee_status=`grep ${config_name} ${tee_config_status_path}`
    if [[ ${tee_status} =~ "LOADED" ]]; then
      return 1
    fi
  fi
  return 0
}

#######################################
# Apply selected patch in current target directory
# Globals:
#   I TEE_PATCH_PATH
#   I tee_version
#   I config_name
# Arguments:
#   $1: patch
# Returns:
#   None
#######################################
apply_patch()
{
  local loc_patch_path

  loc_patch_path=${TEE_PATCH_PATH}/
  loc_patch_path+="${config_name}/${tee_version}/"
  loc_patch_path+=$1
  if [ "${1##*.}" != "patch" ];then
    loc_patch_path+=".patch"
  fi

  \git am ${loc_patch_path} &> /dev/null
  if [ $? -ne 0 ]; then
    error "Not possible to apply patch ${loc_patch_path}, please review android_${config_name}.config"
    teardown "ERROR"
    exit 1
  fi
}

#######################################
# Main
#######################################

# Check that the current script is not sourced
if [[ "$0" != "$BASH_SOURCE" ]]; then
  empty_line
  error "This script shall not be sourced"
  empty_line
  usage
  \popd >/dev/null 2>&1
  return
fi

# check the options
while getopts "hvfu-:" option; do
  case "${option}" in
    -)
      # Treat long options
      case "${OPTARG}" in
        help)
          usage
          popd >/dev/null 2>&1
          exit 0
          ;;
        version)
          echo "`basename $0` version ${SCRIPT_VERSION}"
          \popd >/dev/null 2>&1
          exit 0
          ;;
        force)
          force_load=1
          ;;
        user)
          do_user_load=1
          ;;
        *)
          usage
          popd >/dev/null 2>&1
          exit 1
          ;;
      esac;;
    # Treat short options
    h)
      usage
      popd >/dev/null 2>&1
      exit 0
      ;;
    v)
      echo "`basename $0` version ${SCRIPT_VERSION}"
      \popd >/dev/null 2>&1
      exit 0
      ;;
    f)
      force_load=1
      ;;
    u)
      do_user_load=1
      ;;
    *)
      usage
      popd >/dev/null 2>&1
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ $# -gt 0 ]; then
  error "Unknown command : $*"
  usage
  popd >/dev/null 2>&1
  exit 1
fi

if [[ ${do_user_load} == 1 ]]; then
  TEE_CONFIG_FILES=(${TEE_USER_CONFIG_FILES[@]})
else
  TEE_CONFIG_FILES=(${TEE_OS_CONFIG_FILES[@]})
fi

# Parse all required config files
for config_name in "${TEE_CONFIG_FILES[@]}"
do

  TEE_CONFIG_PATH=${TEE_PATCH_PATH}/${config_name}/android_${config_name}.config

  # Check existence of the TEE configuration file
  if [[ ! -f ${TEE_CONFIG_PATH} ]]; then
    error "TEE configuration ${TEE_CONFIG_PATH} file not available"
    popd >/dev/null 2>&1
    exit 1
  fi

  # Check TEE status
  check_tee_status
  tee_status=$?

  if [[ ${tee_status} == 1 ]] && [[ ${force_load} == 0 ]]; then
      blue "The OP-TEE has been already loaded successfully"
      echo " If you want to reload it"
      echo "   execute the script with -f/--force option"
    if [[ ${do_user_load} == 0 ]]; then
      echo "   or remove the file ${TEE_OS_CONFIG_STATUS_PATH}"
    else
      echo "   or remove the file ${TEE_USER_CONFIG_STATUS_PATH}"
    fi
    popd >/dev/null 2>&1
    exit 0
  fi

  if [[ ${do_user_load} == 0 ]]; then
    empty_line
    echo "Start loading the tee os source (OP-TEE OS)"
  fi

  # Start OP-TEE config file parsing
  while IFS='' read -r line || [[ -n $line ]]; do

    echo $line | grep '^TEE_'  >/dev/null 2>&1

    if [ $? -eq 0 ]; then

      line=$(echo "${line: 4}")

      unset tee_value
      tee_value=($(echo $line | awk '{ print $1 }'))

      case ${tee_value} in
        "VERSION" )
          tee_version=($(echo $line | awk '{ print $2 }'))
          ;;
        "GIT_PATH" )
          git_path=($(echo $line | awk '{ print $2 }'))
          if [[ ${do_user_load} == 0 ]]; then
            state "Loading ${config_name} source"
          fi
          if [ -n "${TEE_CACHE_DIR+1}" ]; then
            \git clone -b ${tee_version} --reference ${TEE_CACHE_DIR} ${git_path} ${tee_path}  >/dev/null 2>&1
          else
            \git clone -b ${tee_version} ${git_path} ${tee_path}  >/dev/null 2>&1
          fi
          if [ $? -ne 0 ]; then
            error "Not possible to clone module from ${git_path}"
            teardown "ERROR"
            exit 1
          fi
          ;;
        "GIT_SHA1" )
          git_sha1=($(echo $line | awk '{ print $2 }'))
          \pushd ${tee_path}  >/dev/null 2>&1
          \git checkout ${git_sha1} &> /dev/null
          if [ $? -ne 0 ]; then
            error "Not possible to checkout ${git_sha1} for ${git_path}"
            teardown "ERROR"
            exit 1
          fi
          \popd  >/dev/null 2>&1
          ;;
        "ARCHIVE_PATH" )
          archive_path=($(echo $line | awk '{ print $2 }'))
          if [[ ${do_user_load} == 0 ]]; then
            state "Loading ${config_name} source"
          fi
          \mkdir -p ${tee_path} >/dev/null 2>&1
          \pushd ${tee_path} >/dev/null 2>&1
          \wget ${archive_path}/archive/${tee_version}.tar.gz >/dev/null 2>&1
          if [ $? -ne 0 ]; then
            error "Not possible to load ${archive_path}/archive/${tee_version}.tar.gz"
            teardown "ERROR"
            exit 1
          fi
          archive_dir=($(basename ${archive_path}))
          \tar zxf ${tee_version}.tar.gz --strip=1 ${archive_dir}-${tee_version} >/dev/null 2>&1
          \rm -f ${tee_version}.tar.gz >/dev/null 2>&1
          \git init >/dev/null 2>&1
          \git commit --allow-empty -m "Initial commit" >/dev/null 2>&1
          \git add . >/dev/null 2>&1
          \git commit -m "v${tee_version}" >/dev/null 2>&1
          \popd >/dev/null 2>&1
          ;;
        "FILE_PATH" )
          if [[ ${msg_patch} == 1 ]]; then
            \popd >/dev/null 2>&1
          fi
          tee_path=($(echo $line | awk '{ print $2 }'))
          msg_patch=0
          \rm -rf ${tee_path}
          if [[ ${force_load} == 1 ]]; then
            if [[ ${do_user_load} == 1 ]]; then
              \rm -f ${TEE_USER_CONFIG_STATUS_PATH}
            else
              \rm -f ${TEE_OS_CONFIG_STATUS_PATH}
            fi
          fi
          ;;
        "PATCH"* )
          patch_path=($(echo $line | awk '{ print $2 }'))
          if [[ ${msg_patch} == 0 ]]; then
            if [[ ${do_user_load} == 0 ]]; then
              state "Applying required patches to ${tee_path}"
            fi
            pushd ${tee_path}  >/dev/null 2>&1
            msg_patch=1
          fi
          apply_patch "${patch_path}"
          ;;
      esac
    fi
  done < ${TEE_CONFIG_PATH}

  if [[ ${do_user_load} == 0 ]]; then
    echo "${config_name} LOADED" >> ${TEE_OS_CONFIG_STATUS_PATH}
    clear_line
    green "The ${config_name} has been successfully loaded in ${tee_path}"
  else
    echo "${config_name} LOADED" >> ${TEE_USER_CONFIG_STATUS_PATH}
  fi

done

teardown "OK"
