/**
 * Copyright Soramitsu Co., Ltd. 2017 All Rights Reserved.
 * http://soramitsu.co.jp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "IRModelProtoQuery.h"
#import "bindings/model_proto.hpp"
#import "bindings/model_query_builder.hpp"
#import "bindings/model_crypto.hpp"

using namespace std;
using namespace shared_model;
using namespace shared_model::proto;
using namespace shared_model::crypto;
using namespace shared_model::bindings;

// с++ classes
typedef Keypair KeypairCpp;
typedef PrivateKey PrivateKeyCpp;
typedef PublicKey PublicKeyCpp;

typedef ModelProto<UnsignedWrapper<proto::Query>> ModelProtoQueryCpp;

typedef UnsignedWrapper<Query> UnsignedQueryWrapperCpp;

// obj-c classes
typedef IRKeypair KeypairObjC;

struct KeypairImpl {
    KeypairCpp keypairCpp;
};

struct UnsignedQueryImpl {
    UnsignedQueryWrapperCpp* unsignedQueryCpp;

    UnsignedQueryImpl(UnsignedQueryWrapperCpp unsignedQuery) {
        unsignedQueryCpp = new UnsignedQueryWrapperCpp(unsignedQuery);
    }
};

struct ModelProtoQueryImpl {
    ModelProtoQueryCpp *modelProtoQueryCpp;

    ModelProtoQueryImpl(UnsignedQueryWrapperCpp unsignedQueryWrapperCpp) {
        modelProtoQueryCpp = new ModelProtoQueryCpp(unsignedQueryWrapperCpp);
    }
};

@implementation IRModelProtoQuery

- (id)initWith:(IRUnsignedQuery*)unsignedQueryObjC {
    self = [super init];
    if (self) {
        modelProtoQueryImpl =
        new ModelProtoQueryImpl(*[unsignedQueryObjC getUnsignedQuery].unsignedQueryCpp);
    }
    return self;
}

-(NSData*)signQuery:(IRUnsignedQuery*)unsignedQueryObjC
        withKeypair:(IRKeypair*)keypair {
    modelProtoQueryImpl = new ModelProtoQueryImpl(*[unsignedQueryObjC getUnsignedQuery].unsignedQueryCpp);
    KeypairImpl keypairImpl = [keypair getKeypair];
    modelProtoQueryImpl->modelProtoQueryCpp = new ModelProtoQueryCpp(modelProtoQueryImpl->modelProtoQueryCpp->signAndAddSignature(keypairImpl.keypairCpp));
    Blob blob = modelProtoQueryImpl->modelProtoQueryCpp->finish();
    return [[NSData alloc] initWithBytes:blob.blob().data()
                                  length:blob.size()];
}

@end
