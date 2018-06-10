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

#import "IRUnsignedtransaction.h"
#import "bindings/model_transaction_builder.hpp"

using namespace std;
using namespace shared_model;
using namespace shared_model::bindings;
using namespace shared_model::proto;

typedef UnsignedWrapper<proto::Transaction> UnsignedTransactionCpp;

// TODO: Redesign like in IRKeypair.mm
struct UnsignedTransactionImpl {
    UnsignedTransactionCpp* unsignedTransactionCpp;

    UnsignedTransactionImpl(UnsignedTransactionCpp transaction) {
        unsignedTransactionCpp = &transaction;
    }
};

@implementation IRUnsignedTransaction

- (id)init:(struct UnsignedTransactionImpl*) unsignedWrapper {
    self = [super init];
    if (self) {
        unsignedTransactionImpl = unsignedWrapper;
    }
    return self;
}

-(void)setWrapper:(struct UnsignedTransactionImpl*)unsignedWrapper {
    unsignedTransactionImpl = unsignedWrapper;
}

-(struct UnsignedTransactionImpl)getUnsignedTransaction {
    return *(unsignedTransactionImpl);
}

@end
