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
#import "IRUnsignedQuery.h"
#import "IRKeypair.h"

/**
 * Using private implementation or PIMPL approach inside implementation of this interface
 */
@interface IRModelProtoQuery : NSObject {
@private
    struct ModelProtoQueryImpl* modelProtoQueryImpl;
}

- (id)initWith:(IRUnsignedQuery*)unsignedQueryObjC;

///**
//* Signs unsigned query and adds signature to its internal proto
//* object
//* @param unsignedQueryObjC - query transaction
//* @param keypair - keypair to sign
//* @return blob of signed transaction
//*/
-(NSData*)signQuery:(IRUnsignedQuery*)unsignedQueryObjC
        withKeypair:(IRKeypair*)keypair;

@end
