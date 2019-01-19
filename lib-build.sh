#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
    echo "Only MacOS is supported"
    exit 1
fi

grpc="protoc-gen-objcgrpc"

command -v protoc >/dev/null 2>&1 || { echo "protoc is required to continue..." >&2; exit 1; }
command -v $grpc >/dev/null 2>&1 || { echo "protoc-gen-objcgrpc is required to continue..." >&2; exit 1; }

IROHA_PATH="iroha"
SCHEMA_PATH="Schema"
PROTOLIB_PATH="protobuf"
PROTO_GEN="ProtoGen"

[ -d $IROHA_PATH ] && rm -rf $IROHA_PATH

git clone -b dev --depth=1 https://github.com/hyperledger/iroha

[ -d $SCHEMA_PATH ] && rm -rf $SCHEMA_PATH
mkdir $SCHEMA_PATH

cp -R "$IROHA_PATH/shared_model/schema" "$SCHEMA_PATH/proto"

[ -d $PROTO_GEN ] && rm -rf $PROTO_GEN
mkdir $PROTO_GEN

grpc_path=$(command -v $grpc)
protoc --plugin=protoc-gen-grpc=$grpc_path --objc_out=${PROTO_GEN} --grpc_out=${PROTO_GEN} --proto_path=./${SCHEMA_PATH}/proto ./${SCHEMA_PATH}/proto/*.proto

[ -d $IROHA_PATH ] && rm -rf $IROHA_PATH
[ -d $SCHEMA_PATH ] && rm -rf $SCHEMA_PATH