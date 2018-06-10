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

#import "IRModelProtoTransaction.h"
#import "bindings/model_proto.hpp"
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

typedef ModelProto<UnsignedWrapper<proto::Transaction>> ModelProtoTransactionCpp;

typedef UnsignedWrapper<Transaction> UnsignedTransactionWrapperCpp;

// obj-c classes
typedef IRKeypair KeypairObjC;

struct KeypairImpl {
    KeypairCpp keypairCpp;
};

struct UnsignedTransactionImpl {
    UnsignedTransactionWrapperCpp* unsignedTransactionCpp;

    UnsignedTransactionImpl(UnsignedTransactionWrapperCpp transaction) {
        unsignedTransactionCpp = new UnsignedTransactionWrapperCpp(transaction);
    }
};

struct ModelProtoTransactionImpl {
    ModelProtoTransactionCpp *modelProtoTransactionCpp;

    ModelProtoTransactionImpl(UnsignedTransactionWrapperCpp unsignedTransactionWrapperCpp) {
        modelProtoTransactionCpp = new ModelProtoTransactionCpp(unsignedTransactionWrapperCpp);
    }
};

@implementation IRModelProtoTransaction

- (id)initWith:(IRUnsignedTransaction*)unsignedTransactionObjC {
    self = [super init];
    if (self) {
        modelProtoTransactionImpl =
        new ModelProtoTransactionImpl(*[unsignedTransactionObjC getUnsignedTransaction].unsignedTransactionCpp);
    }
    return self;
}

-(NSData*)signTransaction:(IRUnsignedTransaction*)unsignedTransactionObjC
              withKeypair:(KeypairObjC*)keypair {
    modelProtoTransactionImpl =
    new ModelProtoTransactionImpl(*[unsignedTransactionObjC getUnsignedTransaction].unsignedTransactionCpp);
    KeypairImpl keypairImpl = [keypair getKeypair];
    modelProtoTransactionImpl->modelProtoTransactionCpp = new ModelProtoTransactionCpp(
    modelProtoTransactionImpl->modelProtoTransactionCpp->signAndAddSignature(keypairImpl.keypairCpp));
    Blob blob = modelProtoTransactionImpl->modelProtoTransactionCpp->finish();
    return [[NSData alloc] initWithBytes:blob.blob().data()
                                  length:blob.size()];
}

@end
