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

#import "IRModelCrypto.h"
#import "bindings/model_crypto.hpp"

#import "bindings/model_proto.hpp"
#import "bindings/model_query_builder.hpp"
#import "bindings/model_transaction_builder.hpp"
#import "bindings/model_crypto.hpp"

using namespace std;
using namespace shared_model;
using namespace shared_model::bindings;
using namespace shared_model::crypto;

// с++ classes
typedef ModelCrypto ModelCryptoCpp;
typedef Keypair KeypairCpp;
typedef PrivateKey PrivateKeyCpp;
typedef PublicKey PublicKeyCpp;

// obj-c classes
typedef IRKeypair KeypairObjC;

struct ModelCryptoImpl {
    ModelCryptoCpp modelCryptoCpp;
};

struct KeypairImpl {
    KeypairCpp keypairCpp;

    KeypairImpl(KeypairCpp keypair) : keypairCpp(keypair.publicKey(), keypair.privateKey())  {
        keypairCpp = KeypairCpp(keypair.publicKey(),
                                keypair.privateKey());
    }
};

@implementation IRModelCrypto

- (id)init {
    self = [super init];
    if (self) {
        modelCryptoImpl = new ModelCryptoImpl;
    }
    return self;
}

- (void)dealloc {
    delete modelCryptoImpl;
}

- (KeypairObjC*)convertKeypairFromCppToObjC:(KeypairCpp)keypairCpp  {

    // Getting private and public keys from c++ keypair object
    PublicKeyCpp publicKeyCpp = keypairCpp.publicKey();
    PrivateKeyCpp privateKeyCpp = keypairCpp.privateKey();

    // Converting private and public keys from c++ std::string to c strings
    const char* publicKeyC = publicKeyCpp.hex().c_str();
    const char* privateKeyC = privateKeyCpp.hex().c_str();

    // Converting c strings to obj-c NSString
    NSString *publicKeyObjC = [NSString stringWithCString:publicKeyC
                                                 encoding:[NSString defaultCStringEncoding]];
    NSString *privateKeyObjC = [NSString stringWithCString:privateKeyC
                                                  encoding:[NSString defaultCStringEncoding]];

    // Initialize keypair obj-c object from NSString
    KeypairObjC *keypairObjC = [[KeypairObjC alloc] initWithPublicKey:publicKeyObjC
                                                       withPrivateKey:privateKeyObjC];

    KeypairImpl* keypairImpl = new KeypairImpl(keypairCpp);

    [keypairObjC setKeypair:keypairImpl];

    return keypairObjC;
}

- (KeypairObjC*)generateKeypair {

    // Generating keypair from c++ lib
    KeypairCpp keypairCpp = modelCryptoImpl->modelCryptoCpp.generateKeypair();

    // Convert from c++ to obj-c
    KeypairObjC *keypairObjC = [self convertKeypairFromCppToObjC:keypairCpp];

    return keypairObjC;
}

- (KeypairObjC*)generateKeypairFromPrivateKey:(NSString*)privateKey {
    string privateKeyCpp = [self getStringCppWithString:privateKey];

    // Generating keypair from c++ lib
    KeypairCpp keypairCpp = modelCryptoImpl->modelCryptoCpp.fromPrivateKey(privateKeyCpp);
    
    // Convert from c++ to obj-c
    KeypairObjC *keypairObjC = [self convertKeypairFromCppToObjC:keypairCpp];

    return keypairObjC;
}

- (KeypairObjC*) generateFromExistingKeypair:(IRKeypair*) keypair {

    NSString *publicKey = keypair.publicKey;
    NSString *privateKey = keypair.privateKey;

    string publicKeyCpp = [self getStringCppWithString:publicKey];
    string privateKeyCpp = [self getStringCppWithString:privateKey];

    // Generating keypair from c++ lib
    KeypairCpp keypairCpp = modelCryptoImpl->modelCryptoCpp.convertFromExisting(publicKeyCpp,
                                                                                privateKeyCpp);
    // Converting keypair from c++ to obj-c
    KeypairObjC *keypairObjC = [self convertKeypairFromCppToObjC:keypairCpp];
    return keypairObjC;
}

-(string)getStringCppWithString:(NSString*)stringObjC {
    string stringCpp = string([stringObjC UTF8String],
                              [stringObjC lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    cout << stringCpp;
    cout << "\n";
    cout << stringCpp.length();
    cout << "\n";
    cout << "\n";
    return stringCpp;
}

@end
