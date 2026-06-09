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
SCRIPT_VERSION="1.7"

SOC_FAMILY="stm32mp2"
SOC_NAME="stm32mp25"
SOC_VERSIONS=( "stm32mp257f" )

if [ -n "${ANDROID_BUILD_TOP+1}" ]; then
  TOP_PATH=${ANDROID_BUILD_TOP}
elif [ -d "device/stm/${SOC_FAMILY}-tee" ]; then
  TOP_PATH=$PWD
else
  echo "ERROR: ANDROID_BUILD_TOP env variable not defined, this script shall be executed on TOP directory"
  exit 1
fi

\pushd ${TOP_PATH} >/dev/null 2>&1

TEE_PREBUILT_PATH="device/stm/${SOC_FAMILY}-tee/prebuilt"

# Board name and flavour shall be listed in associated order (max : two boards)
DEFAULT_BOARD_NAME_LIST=( "eval" "dk" )
DEFAULT_BOARD_FLAVOUR_LIST=( "ev1" "dk" )

#######################################
# Variables
#######################################
nb_states=0
do_install=0

do_debug=0

verbose="--quiet"
verbose_level=0

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
  echo "  This script allows building TRUSTY sources"
  empty_line
  echo "Options:"
  echo "  -h / --help: print this message"
  echo "  -i / --install: update prebuilt images"
  echo "  -v / --version: get script version"
  echo "  --verbose: enable build verbosity"
  echo "  -d / --debug : script debug verbosity"
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
# Print debug message in green
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
debug()
{
  if [[ ${do_debug} == 1 ]]; then
    echo "$(tput setaf 2)DEBUG: $1$(tput sgr0)"
  fi
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

  # one generation per soc
  nb_states=1

  # one installation per board
  if [[ ${do_install} == 1 ]]; then
    board_nb=${#board_name_list[@]}
    nb_states=$((nb_states+${board_nb}))
  fi

  # duplicate states for each soc
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
# Generate TEE binary
# Globals:
#   I soc_version
# Arguments:
#   None
# Returns:
#   None
#######################################
generate_tee()
{
  debug "./trusty/vendor/google/aosp/scripts/build.py ${soc_version}"
  ./trusty/vendor/google/aosp/scripts/build.py ${soc_version} &>${redirect_out}

  if [ $? -ne 0 ]; then
    error "Not possible to generate the TRUSTY OS images"
    \popd >/dev/null 2>&1
    exit 1
  fi
}

#######################################
# Install TEE OS
# Globals:
#   I soc_version
#   I board_flavour
#   I TEE_PREBUILT_PATH
# Arguments:
#   None
# Returns:
#   None
#######################################
install_tee()
{
  if [ ! -d "${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}" ]; then
    \mkdir -p ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}
  fi

  \rm -rf ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/*

  debug "cp ./build-root/build-${soc_version}/lk.bin ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/tee-${soc_version}-${board_flavour}.bin"
  cp ./build-root/build-${soc_version}/lk.bin ${TEE_PREBUILT_PATH}/${soc_version}-${board_flavour}/tee-${soc_version}-${board_flavour}.bin

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
while getopts "hvid-:" option; do
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
        verbose)
          redirect_out="/dev/stdout"
          verbose=
          ;;
        debug)
          do_debug=1
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
    d)
      do_debug=1
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
  error "unknown command $*"
  usage
  popd >/dev/null 2>&1
  exit 1
fi

init_nb_states

for soc_version in "${SOC_VERSIONS[@]}"
do

  # generate binaries for soc
  state "Generate TRUSTY image for ${soc_version} device"
  generate_tee

  if [[ ${do_install} == 1 ]]; then
    for board_name in "${board_name_list[@]}"
    do
      update_board_flavour "${board_name}"

      # Update prebuilt images in required directory
      state "Update TRUSTY prebuilt image for ${soc_version}-${board_flavour} board"
      install_tee

    done
  fi
done

popd >/dev/null 2>&1
