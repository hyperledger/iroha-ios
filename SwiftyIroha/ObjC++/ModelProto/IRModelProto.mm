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

#import "IRModelProto.h"
#import "bindings/model_proto.hpp"
#import "bindings/model_query_builder.hpp"
#import "bindings/model_transaction_builder.hpp"
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

typedef ModelProto<UnsignedWrapper<proto::Query>> QueryForSigningCpp;
typedef ModelProto<UnsignedWrapper<proto::Transaction>> TransactionForSigningCpp;

typedef UnsignedWrapper<proto::Query> UnsignedQueryCpp;
typedef UnsignedWrapper<proto::Transaction> UnsignedTransactionCpp;

// obj-c classes
typedef IRKeypair KeypairObjC;

struct KeypairImpl {
    KeypairCpp keypairCpp;
};

struct UnsignedTransactionImpl {
    UnsignedTransactionCpp* unsignedTransactionCpp;

    UnsignedTransactionImpl(UnsignedTransactionCpp transaction) {
        unsignedTransactionCpp = &transaction;
    }
};

typedef UnsignedWrapper<proto::Query> UnsignedQueryCpp;

struct UnsignedQueryImpl {
    UnsignedQueryCpp* unsignedQueryCpp;

    UnsignedQueryImpl(UnsignedQueryCpp unsignedQuery) {
        unsignedQueryCpp = &unsignedQuery;
    }
};

struct ModelProtoImpl {
    QueryForSigningCpp queryForSigningCpp;
    TransactionForSigningCpp transactionForSigningCpp;
};

@implementation IRModelProto

- (id)init {
    self = [super init];
    if (self) {
        modelProtoImpl = new ModelProtoImpl;
    }
    return self;
}

-(NSData*)signTransaction:(IRUnsignedtransaction*)transactionForSigning
              withKeypair:(KeypairObjC*)keypair {
    UnsignedTransactionImpl unsignedTransactionImpl = [transactionForSigning getUnsignedTransaction];
    KeypairImpl keypairImpl = [keypair getKeypair];
    Blob blob = modelProtoImpl->transactionForSigningCpp.signAndAddSignature(*unsignedTransactionImpl.unsignedTransactionCpp,
                                                                             keypairImpl.keypairCpp);
    return [[NSData alloc] initWithBytes:blob.blob().data()
                                  length:blob.size()];
}

-(NSData*)signQuery:(IRUnsignedQuery*)queryForSigning
        withKeypair:(IRKeypair*)keypair {
    UnsignedQueryImpl unsignedQueryImpl = [queryForSigning getUnsignedQuery];
    KeypairImpl keypairImpl = [keypair getKeypair];
    Blob blob = modelProtoImpl->queryForSigningCpp.signAndAddSignature(*unsignedQueryImpl.unsignedQueryCpp, keypairImpl.keypairCpp);
    return [[NSData alloc] initWithBytes:blob.blob().data()
                                  length:blob.size()];
}

@end
