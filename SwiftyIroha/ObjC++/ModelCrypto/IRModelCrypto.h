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

#import <Foundation/Foundation.h>
#import "IRKeypair.h"

/**
 * Using private implementation or PIMPL approach inside implementation of this interface
 */
@interface IRModelCrypto : NSObject {
@private
    struct ModelCryptoImpl* modelCryptoImpl;
}

-(id)init;

/**
 * Generates new keypair (ed25519)
 * @return generated keypair
 */
- (IRKeypair*)generateKeypair;

/**
 * Creates keypair (ed25519) from provided private key
 * @param privateKey - ed25519 hex-encoded private key
 * @return created keypair
 */
- (IRKeypair*)generateKeypairFromPrivateKey:(NSString*)privateKey;

/**
 * Retrieves Keypair object (ed25519) from existing keypair.
 * @param keypair - ed25519 hex-encoded public key
 * @return keypair from provided keys
 */
- (IRKeypair*)generateFromExistingKeypair:(IRKeypair*) keypair;

@end
