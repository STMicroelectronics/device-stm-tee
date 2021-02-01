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
SCRIPT_VERSION="1.3"

SOC_FAMILY="stm32mp1"
SOC_NAME="stm32mp15"
SOC_VERSIONS=( "stm32mp157c" "stm32mp157f" )

# OP-TEE
TEE_ARCH=arm
TEE_TOOLCHAIN=gcc-arm-9.2-2019.12-x86_64-arm-none-eabi

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
TEE_CROSS_COMPILE=arm-none-eabi-

TEE_OUT=${TOP_PATH}/out-bsp/${SOC_FAMILY}/TEE_OBJ

# Board name and flavour shall be listed in associated order (max : two boards)
DEFAULT_BOARD_NAME_LIST=( "eval" )
DEFAULT_BOARD_FLAVOUR_LIST=( "ev1" )

# Debug available levels
TEE_DEBUG_0="CFG_TEE_CORE_DEBUG=n"
TEE_DEBUG_2="CFG_TEE_CORE_DEBUG=y CFG_TEE_CORE_LOG_LEVEL=2 CFG_TEE_TA_LOG_LEVEL=2"
TEE_DEBUG_3="CFG_TEE_CORE_DEBUG=y CFG_TEE_CORE_LOG_LEVEL=3 CFG_TEE_TA_LOG_LEVEL=3"

# RPMB base configuration
TEE_RPMB_CONFIG="CFG_RPMB_FS=y CFG_RPMB_FS_DEV_ID=1 CFG_RPMB_TESTKEY=y "
# TAKE CARE: write key used to provision RPMB key (fuse), no possibility to come back.
TEE_RPMB_CONFIG+="CFG_RPMB_WRITE_KEY=y "

# Used to reset RPMB (must be performed only once, reboot is not possible with this configuration)
# TEE_RPMB_CONFIG+="CFG_RPMB_RESET_FAT=y "

# Used to trace callstack in case of TA/TEE panic error
# Use device/stm/${SOC_FAMILY}-tee/opteeos-${SOC_FAMILY}/scripts/symbolize.py script to help understanding callstack
# Before update the script: replace arm-linux-gnueabihf- by arm-linux-gnueabihf-
# TEE_RPMB_CONFIG+="CFG_UNWIND=y "

# case 1:  REE FS used for secure storage, RPMB used only to store anti-rollback hash of the REE FS
TEE_RPMB_CONFIG_1="$TEE_RPMB_CONFIG CFG_REE_FS=y"
# case 2:  RPMB used for secure storage including the anti-rollback hash
TEE_RPMB_CONFIG_2="$TEE_RPMB_CONFIG CFG_REE_FS=n"

#######################################
# Variables
#######################################
nb_states=0
do_install=0
do_onlyclean=0

verbose="--quiet"
verbose_level=0

tee_debug=${TEE_DEBUG_0}
tee_config=""
enable_rpmb=0
rpmb_level=0

# By default redirect stdout and stderr to /dev/null
redirect_out="/dev/null"

board_name_list=("${DEFAULT_BOARD_NAME_LIST[@]}")

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
  echo "Usage: `basename $0` [Options] [Command]"
  empty_line
  echo "  This script allows building the OP-TEE OS source"
  empty_line
  echo "Options:"
  echo "  -h / --help: print this message"
  echo "  -i / --install: update prebuilt images"
  echo "  -r <level> / --rpmb=<level>:"
  echo "      0: disable RPMB (default)"
  echo "      1: enable RPMB with TESTKEY for anti-rollback only (TAKE CARE: CFG_RPMB_WRITE_KEY is enabled, fusing the TESTKEY on your device)"
  echo "      2: enable RPMB with TESTKEY for secure storage (TAKE CARE: CFG_RPMB_WRITE_KEY is enabled, fusing the TESTKEY on your device)"
  echo "  -v / --version: get script version"
  echo "  --verbose=<level>: enable build verbosity"
  echo "      0: no verbosity (default)"
  echo "      1: remove script filtering"
  echo "      2: remove script filtering and quiet option for the build"
  echo "  -d <level> / --debug=<level>: TEE debug level"
  echo "      0: no debug (default)"
  echo "      1: TEE core and TA log level 2"
  echo "      2: TEE core and TA log level 3"
  echo "  -b <name> / --board=<name>: set board name from following list = ${DEFAULT_BOARD_NAME_LIST[*]} (default: all)"
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
  if [ ${do_onlyclean} == 1 ]; then
    nb_states=$((nb_states+1))
  else
    nb_states=$((nb_states+1))
    if [[ ${do_install} == 1 ]]; then
      nb_states=$((nb_states+1))
    fi
  fi

  board_nb=${#board_name_list[@]}
  nb_states=$((nb_states*${board_nb}))

  soc_nb=${#SOC_VERSIONS[@]}
  nb_states=$((nb_states*${soc_nb}))
}

#######################################
# Update board flavour based on board name
# Globals:
#   I DEFAULT_BOARD_NAME_LIST
#   I DEFAULT_BOARD_FLAVOUR_LIST
#   O board_flavour
# Arguments:
#   $1 = Board name
# Returns:
#   None
#######################################
update_board_flavour()
{
  if [[ $1 == ${DEFAULT_BOARD_NAME_LIST[0]} ]]; then
    board_flavour=${DEFAULT_BOARD_FLAVOUR_LIST[0]}
  else
    board_flavour=${DEFAULT_BOARD_FLAVOUR_LIST[1]}
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
  \make ${verbose} -j8 -C ${tee_src} O=${TEE_OUT}/${soc_version}-${board_flavour} \
    ARCH="${TEE_ARCH}" CROSS_COMPILE=${TEE_CROSS_COMPILE_PATH}/${TEE_CROSS_COMPILE} \
    ${tee_debug} ${tee_config} PLATFORM=${SOC_FAMILY} \
    CFG_EMBED_DTB_SOURCE_FILE=${tee_dtb}.dts $1 &>${redirect_out}

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
#   I soc_version
# Arguments:
#   None
# Returns:
#   None
#######################################
install_tee()
{
  if [ ! -d "${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}" ]; then
    \mkdir -p ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}
    \mkdir -p ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/optee_os
    \mkdir -p ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/export-ta_arm32
  fi

  \rm -rf ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/optee_os/*
  \rm -rf ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/export-ta_arm32/*

  \find ${TEE_OUT}/${soc_version}-${board_flavour}/ -name "${TEE_HEADER}.${TEE_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/optee_os/${TEE_HEADER}-${soc_version}-${board_flavour}.${TEE_EXT}
  \find ${TEE_OUT}/${soc_version}-${board_flavour}/ -name "${TEE_PAGEABLE}.${TEE_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/optee_os/${TEE_PAGEABLE}-${soc_version}-${board_flavour}.${TEE_EXT}
  \find ${TEE_OUT}/${soc_version}-${board_flavour}/ -name "${TEE_PAGER}.${TEE_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/optee_os/${TEE_PAGER}-${soc_version}-${board_flavour}.${TEE_EXT}
  \cp -rf ${TEE_OUT}/${soc_version}-${board_flavour}/export-ta_arm32/* ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/export-ta_arm32/
  \find ${TEE_OUT}/${soc_version}-${board_flavour}/ -name "tee.${TEE_ELF_EXT}" -print0 | xargs -0 -I {} cp {} ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/optee_os/tee-${soc_version}-${board_flavour}.${TEE_ELF_EXT}
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
while getopts "hvir:d:b:-:" option; do
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
        install)
          do_install=1
          ;;
        rpmb=*)
          rpmb_level=${OPTARG#*=}
          if ! in_list "0 1 2" "${rpmb_level}"; then
            error "unknown rpmb level ${rpmb_level}"
            \popd >/dev/null 2>&1
            exit 1
          fi
          if [ ${rpmb_level} != 0 ]; then
            enable_rpmb=1
          fi
          ;;
        verbose=*)
          verbose_level=${OPTARG#*=}
          if ! in_list "0 1 2" "${verbose_level}"; then
            error "unknown verbose level ${verbose_level}"
            \popd >/dev/null 2>&1
            exit 1
          fi
          if [ ${verbose_level} != 0 ];then
            redirect_out="/dev/stdout"
          fi
          if [ ${verbose_level} == 2 ];then
            verbose=
          fi
          ;;
        debug=*)
          debug_arg=${OPTARG#*=}
          case ${debug_arg} in
            "0" )
            tee_debug=${TEE_DEBUG_0}
            ;;
            "1" )
            tee_debug=${TEE_DEBUG_2}
            ;;
            "2" )
            tee_debug=${TEE_DEBUG_3}
            ;;
            ** )
              error "unknown debug level ${debug_arg}"
              \popd >/dev/null 2>&1
              exit 1
              ;;
          esac
          ;;
        board=*)
          board_arg=${OPTARG#*=}
          if ! in_list "${DEFAULT_BOARD_NAME_LIST[*]}" "${board_arg}"; then
            error "unknown board name ${board_arg}"
            popd >/dev/null 2>&1
            exit 1
          fi
          board_name_list=( "${board_arg}" )
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
    i)
      do_install=1
      ;;
    r)
      rpmb_level=${OPTARG}
      if ! in_list "0 1 2" "${rpmb_level}"; then
        error "unknown rpmb level ${rpmb_level}"
        \popd >/dev/null 2>&1
        exit 1
      fi
      if [ ${rpmb_level} != 0 ]; then
        enable_rpmb=1
      fi
      ;;
    d)
      case ${OPTARG} in
        "0" )
        tee_debug=${TEE_DEBUG_0}
        ;;
        "1" )
        tee_debug=${TEE_DEBUG_2}
        ;;
        "2" )
        tee_debug=${TEE_DEBUG_3}
        ;;
        ** )
          error "unknown debug level ${OPTARG}"
          \popd >/dev/null 2>&1
          exit 1
          ;;
      esac
      ;;
    b)
      if ! in_list "${DEFAULT_BOARD_NAME_LIST[*]}" "${OPTARG}"; then
        error "unknown board name ${OPTARG}"
        popd >/dev/null 2>&1
        exit 1
      fi
      board_name_list=( "${OPTARG}" )
      ;;
    *)
      usage
      popd >/dev/null 2>&1
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ $# -gt 1 ]; then
  error "Only one command resquest supported. Current commands are : $*"
  usage
  popd >/dev/null 2>&1
  exit 1
fi

# check the command if available
if [ $# -eq 1 ]; then

  case $1 in
    "clean" )
      do_onlyclean=1
      ;;

    ** )
      usage
      popd >/dev/null 2>&1
      exit 1
      ;;
  esac
fi

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

for soc_version in "${SOC_VERSIONS[@]}"
do
  for board_name in "${board_name_list[@]}"
  do
    update_board_flavour "${board_name}"

    # Create TEE out directory
    \mkdir -p ${TEE_OUT}/${soc_version}-${board_flavour}

    # Set TEE DTB name used
    tee_dtb=${soc_version}-${board_flavour}

    # Set TEE config depending on board capability
    tee_config=""
    if [ ${board_name} == "eval" ]; then
      case ${rpmb_level} in
        "1" )
        tee_config=${TEE_RPMB_CONFIG_1}
        ;;
        "2" )
        tee_config=${TEE_RPMB_CONFIG_2}
        ;;
      esac
    fi

    if [ ${do_onlyclean} == 1 ]; then
      state "Clean out directory for ${soc_version}-${board_flavour} board"
      generate_tee clean
    else
      # Build TEE
      state "Generate OP-TEE OS images for ${soc_version}-${board_flavour} board"
      generate_tee all

      if [[ ${do_install} == 1 ]]; then
        # Update prebuilt images in required directory
        state "Update prebuilt images for ${soc_version}-${board_flavour} board"
        install_tee
      fi
    fi
  done
done

if [ ${enable_rpmb} == 1 ]; then
  empty_line
  blue "  RPMB has been enabled with ${tee_config}"
  empty_line
  blue "  It's recommended to disable de RPMB emulator in the tee-supplicant:"
  blue "    Set \"RPMB_EMU := 0\" in device/stm/stm32mp1/tee/optee_client/tee-supplicant/tee_supplicant_android.mk"
  empty_line
  blue "  Reminder: the RPMB key (TESTKEY) will be definitively provisioned (fuse) on the device, if not already performed"
else
  empty_line
  blue "  RPMB has been disabled"
  empty_line
  blue "  It's recommended to enable de RPMB emulator in the tee-supplicant:"
  blue "    Set \"RPMB_EMU := 1\" in device/stm/stm32mp1/tee/optee_client/tee-supplicant/tee_supplicant_android.mk"
fi

popd >/dev/null 2>&1
