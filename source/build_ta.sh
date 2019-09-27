#!/bin/bash
#
# Build OP-TEE TA

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
SCRIPT_VERSION="1.0"

SOC_FAMILY="stm32mp1"
SOC_NAME="stm32mp15"
SOC_VERSION="stm32mp157c"

# OP-TEE
TEE_VERSION=3.3.0
TEE_ARCH=arm

TEE_TOOLCHAIN=gcc-arm-8.2-2019.01-x86_64-arm-eabi

if [ -n "${ANDROID_BUILD_TOP+1}" ]; then
  TOP_PATH=${ANDROID_BUILD_TOP}
elif [ -d "device/stm/${SOC_FAMILY}-tee" ]; then
  TOP_PATH=$PWD
else
  echo "ERROR: ANDROID_BUILD_TOP env variable not defined, this script shall be executed on TOP directory"
  exit 1
fi

\pushd ${TOP_PATH} >/dev/null 2>&1

TA_BUILDCONFIG=android_tabuild.config

TEE_SOURCE_PATH=${TOP_PATH}/device/stm/${SOC_FAMILY}-tee/source
TEE_PREBUILT_PATH=${TOP_PATH}/device/stm/${SOC_FAMILY}-tee/prebuilt

TEE_CROSS_COMPILE_PATH=${TOP_PATH}/prebuilts/gcc/linux-x86/arm/${TEE_TOOLCHAIN}/bin
TEE_CROSS_COMPILE=arm-eabi-

TEE_OUT=${TOP_PATH}/out-bsp/${SOC_FAMILY}/TEE_OBJ

# Board name and flavour shall be listed in associated order
BOARD_NAME_LIST=( "eval" )

#######################################
# Variables
#######################################
nb_states=1
do_install=0

do_all_board=1
board_name=

verbose="--quiet"
verbose_level=0

# By default redirect stdout and stderr to /dev/null
redirect_out="/dev/null"

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
  echo "Usage: `basename $0` [Options] [Board options]"
  empty_line
  echo "  This script allows building the trust applications (TA) source listed in ${TA_BUILDCONFIG} file"
  empty_line
  echo "Options:"
  echo "  -h/--help: print this message"
  echo "  -i/--install: update prebuilt images"
  echo "  -v/--version: get script version"
  echo "  --verbose <level>: enable verbosity (1 or 2 depending on level of verbosity required)"
  empty_line
  echo "Board options:"
  echo "  -c/--current: build only for current configuration (board and memory)"
  echo "  or"
  echo "  -b/--board <name>: set board name from following list = ${BOARD_NAME_LIST[*]} (default: all)"
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
  echo "$(tput setaf 6)  [${action_state}/${nb_states}]: $1 $(tput sgr0)"
  action_state=$((action_state+1))
}

#######################################
# Check if item is available in list
# Globals:
#   None
# Arguments:
#   $1 = list of possible items
#   $2 = item which shall be tested
# Returns:
#   0 if item found in list
#   1 if item not found in list
#######################################
in_list()
{
  local list="$1"
  local checked_item="$2"

  for item in ${list}
  do
    if [[ "$item" == "$checked_item" ]]; then
      return 0
    fi
  done

  return 1
}

#######################################
# Initialize number of states
# Globals:
#   I TEE_SOURCE_PATH
#   I TA_BUILDCONFIG
#   O nb_states
# Arguments:
#   None
# Returns:
#   None
#######################################
init_nb_states()
{
  nb_states=0
  while IFS='' read -r line || [[ -n $line ]]; do
    echo $line | grep '^TA_'  >/dev/null 2>&1

    if [ $? -eq 0 ]; then
      line=$(echo "${line: 3}")
      ta_value=($(echo $line | awk '{ print $1 }'))

      case ${ta_value} in
      "SRC" )
        nb_states=$((nb_states+1))
        ;;
      "NAME" )
        if [[ ${do_install} == 1 ]]; then
          nb_states=$((nb_states+1))
        fi
        ;;
      esac
    fi
  done < ${TEE_SOURCE_PATH}/${TA_BUILDCONFIG}

  if [[ ${do_all_board} == 1 ]]; then
    nb_states=$((nb_states+nb_states))
  fi
}

#######################################
# Generate TEE binary
# Globals:
#   I ta_src
#   I ta_dir
#   I board_name
#   I TA_OUT
#   I TEE_PREBUILT_PATH
#   I TEE_CROSS_COMPILE_PATH
#   I TEE_CROSS_COMPILE
# Arguments:
#   None
# Returns:
#   None
#######################################
generate_ta()
{
  mkdir -p ${TEE_OUT}/${board_name}/ta/${ta_dir}

  \make ${verbose} -j8 -C ${ta_src} O=${TEE_OUT}/${board_name}/ta/${ta_dir} \
    TA_DEV_KIT_DIR=${TEE_PREBUILT_PATH}/${board_name}/export-ta_arm32 \
    CROSS_COMPILE=${TEE_CROSS_COMPILE_PATH}/${TEE_CROSS_COMPILE} &>${redirect_out}

  if [ $? -ne 0 ]; then
    error "Not possible to generate the TA ${ta_name}"
    popd >/dev/null 2>&1
    exit 1
  fi
}

#######################################
# Check TA source availability
# Globals:
#   I ta_src
# Arguments:
#   None
# Returns:
#   None
#######################################
check_ta_src()
{
  if [[ ! -f ${ta_src}/Makefile ]]; then
    error "TA source ${ta_src} not available"
    popd >/dev/null 2>&1
    exit 1
  fi
}

#######################################
# Generate all TA listed in build config file
# Globals:
#   I board_name
#   I TEE_SOURCE_PATH
#   I TEE_PREBUILT_PATH
#   I TA_BUILDCONFIG
# Arguments:
#   None
# Returns:
#   None
#######################################
generate_all_ta()
{
  while IFS='' read -r line || [[ -n $line ]]; do
    echo $line | grep '^TA_'  >/dev/null 2>&1

    if [ $? -eq 0 ]; then
      line=$(echo "${line: 3}")
      ta_value=($(echo $line | awk '{ print $1 }'))

      case ${ta_value} in
      "SRC" )
        tmp_src=($(echo $line | awk '{ print $2 }'))
        ta_src=($(realpath ${tmp_src}))
        check_ta_src
        ta_dir=($(basename ${tmp_src}))
        build_ta=0
        ;;
      "NAME" )
        ta_name=($(echo $line | awk '{ print $2 }'))
        if [[ ${build_ta} == 0 ]]; then
          state "Generate TA ${ta_dir} (${ta_name}) for ${board_name}"
          generate_ta
          build_ta=1
        fi
        if [[ ${do_install} == 1 ]]; then
          state "Update prebuilt image for the TA ${ta_dir} (${ta_name}) for ${board_name}"
          \find ${TEE_OUT}/${board_name}/ta/ -name "${ta_name}.ta" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/${board_name}/ta/${ta_name}.ta
        fi
        ;;
      esac
    fi
  done < ${TEE_SOURCE_PATH}/${TA_BUILDCONFIG}
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

# Check the current usage
if [ $# -gt 5 ]
then
  usage
  popd >/dev/null 2>&1
  exit 0
fi

while test "$1" != ""; do
  arg=$1
  case $arg in
    "-h"|"--help" )
      usage
      popd >/dev/null 2>&1
      exit 0
      ;;

    "-v"|"--version" )
      echo "`basename $0` version ${SCRIPT_VERSION}"
      \popd >/dev/null 2>&1
      exit 0
      ;;

    "-i"|"--install" )
      nb_states=$((nb_states+1))
      do_install=1
      ;;

    "--verbose" )
      verbose_level=${2}
      redirect_out="/dev/stdout"
      if ! in_list "0 1 2" "${verbose_level}"; then
        error "unknown verbose level ${verbose_level}"
        \popd >/dev/null 2>&1
        exit 1
      fi
      if [ ${verbose_level} == 2 ];then
        verbose=
      fi
      shift
      ;;

    "-c"|"--current" )
      if [ -n "${ANDROID_DEFAULT_BOARDNAME+1}" ]; then
        board_name=${ANDROID_DEFAULT_BOARDNAME}
        do_all_board=0
      else
        echo "ANDROID_DEFAULT_BOARDNAME not defined !"
        echo "Please execute \"source ./build/envsetup.sh\" followed by \"lunch\" with appropriate target"
        popd >/dev/null 2>&1
        exit 0
      fi
      do_current=1
      ;;

    "-b"|"--board" )
      board_name=$2
      do_all_board=0
      shift
      ;;

    ** )
      usage
      popd >/dev/null 2>&1
      exit 0
      ;;
  esac
  shift
done

# Check existence of the TEE build configuration file
if [[ ! -f ${TEE_SOURCE_PATH}/${TA_BUILDCONFIG} ]]; then
  error "TEE configuration ${TA_BUILDCONFIG} file not available"
  popd >/dev/null 2>&1
  exit 1
fi

if [[ ! -d ${TEE_CROSS_COMPILE_PATH} ]]; then
  error "Required toolchain ${TEE_TOOLCHAIN} not available, please execute bspsetup"
  popd >/dev/null 2>&1
  exit 1
fi

# Create required directories
\mkdir -p ${TEE_OUT}

# Initialize number of build states
init_nb_states

# Start TA generation
if [[ ${do_all_board} == 1 ]]; then
  for board_name in "${BOARD_NAME_LIST[@]}"
  do
    \mkdir -p ${TEE_OUT}/${board_name}/ta
    if [[ ${do_install} == 1 ]]; then
      \mkdir -p ${TEE_PREBUILT_PATH}/${board_name}/ta
    fi
    generate_all_ta
  done
else
  # Check board name
  if in_list "${BOARD_NAME_LIST[*]}" "${board_name}"; then
    \mkdir -p ${TEE_OUT}/${board_name}/ta
    if [[ ${do_install} == 1 ]]; then
      \mkdir -p ${TEE_PREBUILT_PATH}/${board_name}/ta
    fi
    generate_all_ta
  else
    error "unknown board name ${board_name}"
    popd >/dev/null 2>&1
    exit 1
  fi
fi

popd >/dev/null 2>&1
