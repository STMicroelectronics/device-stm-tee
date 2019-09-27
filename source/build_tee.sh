#!/bin/bash
#
# Build OP-TEE OS

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

# OP-TEE is speparated in three parts:
# header giving information on both pager and pageable parts
# pageable containing part of os which can be paged (in DDR)
# pager continaing part of os which can't be paged (in internal SRAM)
TEE_HEADER="tee-header_v2"
TEE_PAGEABLE="tee-pageable_v2"
TEE_PAGER="tee-pager_v2"
TEE_EXT="stm32"
TEE_ELF_EXT="elf"

if [ -n "${ANDROID_BUILD_TOP+1}" ]; then
  TOP_PATH=${ANDROID_BUILD_TOP}
elif [ -d "device/stm/${SOC_FAMILY}-tee" ]; then
  TOP_PATH=$PWD
else
  echo "ERROR: ANDROID_BUILD_TOP env variable not defined, this script shall be executed on TOP directory"
  exit 1
fi

\pushd ${TOP_PATH} >/dev/null 2>&1

TEE_BUILDCONFIG=android_teebuild.config

TEE_SOURCE_PATH=${TOP_PATH}/device/stm/${SOC_FAMILY}-tee/source
TEE_PREBUILT_PATH=${TOP_PATH}/device/stm/${SOC_FAMILY}-tee/prebuilt

TEE_CROSS_COMPILE_PATH=${TOP_PATH}/prebuilts/gcc/linux-x86/arm/${TEE_TOOLCHAIN}/bin
TEE_CROSS_COMPILE=arm-eabi-

TEE_OUT=${TOP_PATH}/out-bsp/${SOC_FAMILY}/TEE_OBJ

# Board name and flavour shall be listed in associated order
BOARD_NAME_LIST=( "eval" )
BOARD_FLAVOUR_LIST=( "ev1" )

#######################################
# Variables
#######################################
nb_states=1
do_install=0
do_onlyclean=0

do_all_board=1
board_name=

tee_src=

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
  echo "Usage: `basename $0` [Options] [Board] [Command]"
  empty_line
  echo "  This script allows building the OP-TEE OS source"
  empty_line
  echo "Options:"
  echo "  -h/--help: print this message"
  echo "  -i/--install: update prebuilt images"
  echo "  -v/--version: get script version"
  echo "  --verbose <level>: enable verbosity (1 or 2 depending on level of verbosity required)"
  empty_line
  echo "Board: Optional (default = all)"
  echo "  -c/--current: build only for current configuration (board and memory)"
  echo "  or"
  echo "  -b/--board <name>: set board name from following list = ${BOARD_NAME_LIST[*]} (default: all)"
  empty_line
  echo "Command: Optional, only one command at a time supported"
  echo "  clean: execute make clean on targeted module"
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
#   I board_name
#   I do_install
#   O nb_states
# Arguments:
#   None
# Returns:
#   None
#######################################
init_nb_states()
{
  if [[ ${do_all_board} == 1 ]]; then
    if [[ ${do_onlyclean} == 1 ]]; then
      nb_states=2
    else
      if [[ ${do_install} == 1 ]]; then
        nb_states=4
      else
        nb_states=2
      fi
    fi
  else
    if [[ ${do_onlyclean} == 1 ]]; then
      nb_states=1
    else
      if [[ ${do_install} == 1 ]]; then
        nb_states=2
      else
        nb_states=1
      fi
    fi
  fi
}

#######################################
# Update board flavour based on board name
# Globals:
#   I BOARD_NAME_LIST
#   I BOARD_FLAVOUR_LIST
#   O board_flavour
# Arguments:
#   $1 = Board name
# Returns:
#   None
#######################################
update_board_flavour()
{
  if [[ $1 == ${BOARD_NAME_LIST[0]} ]]; then
    board_flavour=${BOARD_FLAVOUR_LIST[0]}
  else
    board_flavour=${BOARD_FLAVOUR_LIST[1]}
  fi
}

#######################################
# Extract TEE build config
# Globals:
#   I TEE_SOURCE_PATH
#   I TEE_BUILDCONFIG
#   O tee_src
# Arguments:
#   None
# Returns:
#   None
#######################################
extract_buildconfig()
{
  local l_tee_value
  local l_line
  local l_src

  while IFS='' read -r l_line || [[ -n $l_line ]]; do
    echo $l_line | grep '^TEE_'  >/dev/null 2>&1

    if [ $? -eq 0 ]; then
      l_line=$(echo "${l_line: 4}")
      l_tee_value=($(echo $l_line | awk '{ print $1 }'))

      case ${l_tee_value} in
      "SRC" )
        l_src=($(echo $l_line | awk '{ print $2 }'))
        tee_src=($(realpath ${l_src}))
        ;;
      esac
    fi
  done < ${TEE_SOURCE_PATH}/${TEE_BUILDCONFIG}
}

#######################################
# Generate TEE binary
# Globals:
#   I tee_src
#   I TEE_OUT
#   I TEE_ARCH
#   I TEE_CROSS_COMPILE_PATH
#   I TEE_CROSS_COMPILE
# Arguments:
#   $1: compilation rule (all or clean)
#   None
# Returns:
#   None
#######################################
generate_tee()
{
  \make ${verbose} -j8 -C ${tee_src} O=${TEE_OUT}/${board_name} ARCH="${TEE_ARCH}" \
    CROSS_COMPILE=${TEE_CROSS_COMPILE_PATH}/${TEE_CROSS_COMPILE} \
    CFG_TEE_CORE_DEBUG=n CFG_TEE_CORE_LOG_LEVEL=2 PLATFORM=${SOC_FAMILY} \
    CFG_SECURE_DT=${tee_dtb} $1 &>${redirect_out}

  if [ $? -ne 0 ]; then
    error "Not possible to generate the OP-TEE OS images"
    \popd >/dev/null 2>&1
    exit 1
  fi
}

#######################################
# Install TEE OS
# Globals:
#   I board_name
#   I board_flavour
#   I TEE_OUT
#   I TEE_HEADER
#   I TEE_PAGEABLE
#   I TEE_PAGER
#   I TEE_EXT
#   I TEE_ELF_EXT
#   I TEE_PREBUILT_PATH
#   I SOC_VERSION
# Arguments:
#   None
# Returns:
#   None
#######################################
install_tee()
{
  \find ${TEE_OUT}/${board_name}/ -name "${TEE_HEADER}.${TEE_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/optee_os/${TEE_HEADER}-${SOC_VERSION}-${board_flavour}.${TEE_EXT}
  \find ${TEE_OUT}/${board_name}/ -name "${TEE_PAGEABLE}.${TEE_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/optee_os/${TEE_PAGEABLE}-${SOC_VERSION}-${board_flavour}.${TEE_EXT}
  \find ${TEE_OUT}/${board_name}/ -name "${TEE_PAGER}.${TEE_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/optee_os/${TEE_PAGER}-${SOC_VERSION}-${board_flavour}.${TEE_EXT}
  \cp -rf ${TEE_OUT}/${board_name}/export-ta_arm32/* ${TEE_PREBUILT_PATH}/${board_name}/export-ta_arm32/
  \find ${TEE_OUT}/${board_name}/ -name "tee.${TEE_ELF_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/optee_os/tee-${SOC_VERSION}-${board_flavour}.${TEE_ELF_EXT}
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
        \popd >/dev/null 2>&1
        exit 0
      fi
      do_current=1
      ;;

    "-b"|"--board" )
      board_name=$2
      do_all_board=0
      shift
      ;;

    "clean" )
      do_onlyclean=1
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
if [[ ! -f ${TEE_SOURCE_PATH}/${TEE_BUILDCONFIG} ]]; then
  error "TEE configuration ${TEE_BUILDCONFIG} file not available"
  popd >/dev/null 2>&1
  exit 1
fi

if [[ ! -d ${TEE_CROSS_COMPILE_PATH} ]]; then
  error "Required toolchain ${TEE_TOOLCHAIN} not available, please execute bspsetup"
  popd >/dev/null 2>&1
  exit 1
fi

# Extract TEE build configuration
extract_buildconfig

# Check existence of the TEE source
if [[ ! -f ${tee_src}/Makefile ]]; then
  error "TEE source ${tee_src} not available, please execute load_tee first"
  popd >/dev/null 2>&1
  exit 1
fi

# Initialize number of build states
init_nb_states

if [[ ${do_all_board} == 1 ]]; then
  for board_name in "${BOARD_NAME_LIST[@]}"
  do
    update_board_flavour "${board_name}"

    # Create TEE out directory
    \mkdir -p ${TEE_OUT}/${board_name}

    # Set TEE DTB name used
    tee_dtb=${SOC_VERSION}-${board_flavour}

    if [ ${do_onlyclean} == 1 ]; then
      state "Clean out directory for ${board_name}"
      generate_tee clean
    else
      # Build TEE
      state "Generate OP-TEE OS images for ${board_name}"
      generate_tee all

      if [[ ${do_install} == 1 ]]; then
        # Update prebuilt images in required directory
        state "Update prebuilt images for ${board_name}"
        install_tee
      fi

    fi
  done
else
  # Check board name
  if in_list "${BOARD_NAME_LIST[*]}" "${board_name}"; then
    update_board_flavour "${board_name}"
  else
    error "unknown board name ${board_name}"
    popd >/dev/null 2>&1
    exit 1
  fi

  # Create TEE out directory
  \mkdir -p ${TEE_OUT}/${board_name}

  # Set TEE DTB name used
  tee_dtb=${SOC_VERSION}-${board_flavour}

  if [ ${do_onlyclean} == 1 ]; then
    state "Clean out directory for ${board_name}"
    generate_tee clean
  else
    # Build TEE
    state "Generate OP-TEE OS images for ${board_name}"
    generate_tee all

    if [[ ${do_install} == 1 ]]; then
      # Update prebuilt images in required directory
      state "Update prebuilt images for ${board_name}"
      install_tee
    fi
  fi
fi

popd >/dev/null 2>&1
