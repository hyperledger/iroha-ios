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

#import "IRKeypair.h"
#import "bindings/model_crypto.hpp"

using namespace std;
using namespace shared_model;
using namespace shared_model::bindings;
using namespace shared_model::crypto;

// с++ classes
typedef Keypair KeypairCpp;

// obj-c classes
typedef IRKeypair KeypairObjC;

struct KeypairImpl {
    KeypairCpp keypairCpp;

    KeypairImpl(KeypairCpp keypair) : keypairCpp(keypair.publicKey(), keypair.privateKey())  {
        keypairCpp = KeypairCpp(keypair.publicKey(),
                                keypair.privateKey());
    }
};

@implementation IRKeypair

- (id)initWithPublicKey: (NSString*)publicKey
          withPrivateKey: (NSString*)privateKey {
    self = [super init];
    if (self) {
        self.privateKey = privateKey;
        self.publicKey = publicKey;
    }
    return self;
}

-(void)setKeypair:(struct KeypairImpl*)keypair {
    keypairImpl = keypair;
}

-(struct KeypairImpl)getKeypair {
    return *(keypairImpl);
}

@end
