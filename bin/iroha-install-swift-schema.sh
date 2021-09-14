#!/bin/bash
#
# Copyright 2021 Soramitsu Co., Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEV_MODE=false
if [ $1 = "--dev" ]; then
   DEV_MODE=true
fi

JSON_SCHEMA_PATH=""
if [ true = "$DEV_MODE" ]; then
  if [ -z "$2" ]; then
    echo "No .xcodeproj path provided"
    exit
  fi
  JSON_SCHEMA_PATH=${2}
  if [ -z "$3" ]; then
    echo "No destination path provided"
    exit
  fi
else
  if [ -z "$1" ]; then
    echo "No .xcodeproj path provided"
    exit
  fi
  JSON_SCHEMA_PATH=${1}
  if [ -z "$2" ]; then
    echo "No .xcodeproj path provided"
    exit
  fi

  if [ -z "$3" ]; then
    echo "No injection group path provided"
    exit
  fi
fi

abspath () { case "$1" in /*)printf "%s\n" "$1";; *)printf "%s\n" "$PWD/$1";; esac; }

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCHEMA_BUILDER_ARGS=""
if [ true = "$DEV_MODE" ]; then
  SCHEMA_BUILDER_ARGS="--dev $(abspath "$JSON_SCHEMA_PATH") $(abspath "$3") $4"
else
  SCHEMA_BUILDER_ARGS="$(abspath "$JSON_SCHEMA_PATH") $(abspath "$2") $3 $4"
fi
${SCRIPT_DIR}/iroha-build-swift-schema $SCHEMA_BUILDER_ARGS

if [ true = "$DEV_MODE" ]; then
  # No need to inject files to .xcodeproj
  exit
fi

if [ -z "$4" ]; then
  echo "No Swift import frameworks list provided"
  exit
fi

XCODEPROJ_VERSION=1.20.0
gem install --install-dir ${SCRIPT_DIR}/.ruby_include xcodeproj -v $XCODEPROJ_VERSION > /dev/null

XCODEPROJ_LIB_PATH=${SCRIPT_DIR}/.ruby_include/gems/xcodeproj-${XCODEPROJ_VERSION}/lib
ruby ${SCRIPT_DIR}/iroha-inject-swift-schema.rb $XCODEPROJ_LIB_PATH $(abspath "$2") $3
