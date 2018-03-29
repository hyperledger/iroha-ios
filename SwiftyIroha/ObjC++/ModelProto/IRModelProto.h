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
#import "IRUnsignedtransaction.h"
#import "IRUnsignedQuery.h"
#import "IRKeypair.h"

/**
 * Using private implementation or PIMPL approach inside implementation of this interface
 */
@interface IRModelProto : NSObject {
@private
    struct ModelProtoImpl* modelProtoImpl;
}

- (id)init;

/**
 * Signs unsigned transaction and adds signature to its internal proto
 * object
 * @param objectForSigning - unsigned transaction
 * @param keypair - keypair to sign
 * @return blob of signed transaction
 */
-(NSData*)signTransaction:(IRUnsignedtransaction*)transactionForSigning
              withKeypair:(IRKeypair*)keypair;

-(NSData*)signQuery:(IRUnsignedQuery*)queryForSigning
        withKeypair:(IRKeypair*)keypair;

@end
