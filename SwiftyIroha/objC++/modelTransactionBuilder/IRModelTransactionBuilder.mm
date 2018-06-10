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

#import "IRModelTransactionBuilder.h"
#import "bindings/model_transaction_builder.hpp"

using namespace std;
using namespace shared_model;
using namespace shared_model::bindings;
using namespace shared_model::proto;
using namespace shared_model::crypto;

typedef IRUnsignedTransaction UnsignedTransactionObjC;

typedef shared_model::bindings::ModelTransactionBuilder TransactionBuilderCpp;
typedef UnsignedWrapper<Transaction> UnsignedTransactionCpp;

struct UnsignedTransactionImpl {
    UnsignedTransactionCpp* unsignedTransactionCpp;

    UnsignedTransactionImpl(UnsignedTransactionCpp transaction) {
        unsignedTransactionCpp = new UnsignedTransactionCpp(transaction);
    }
};

struct TransactionBuilderImpl {
    TransactionBuilderCpp transactionBuilderCpp;
};

@implementation IRModelTransactionBuilder

- (id)init {
    self = [super init];
    if (self) {
        transactionBuilderImpl = new TransactionBuilderImpl;
    }
    return self;
}

- (void)dealloc {
    delete transactionBuilderImpl;
}

-(IRModelTransactionBuilder*)creatorAccountId:(NSString*)creatorAccountId {
    string creatorAccountIdCpp = string([creatorAccountId UTF8String],
                                        [creatorAccountId lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.creatorAccountId(creatorAccountIdCpp);
    return self;
}

-(IRModelTransactionBuilder*)createdTime:(NSDate*)creationTime {
    UInt64 timestamp = (UInt64)([creationTime timeIntervalSince1970]) * 1000;
    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.createdTime(timestamp);
    return self;
}

-(IRModelTransactionBuilder*)addAssetQuantityWithAccountId:(NSString*)accountId
                                              withAssetsId:(NSString*)assetId
                                                withAmount:(NSString*)amount {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string assetIdCpp = [self getStringCppFromStringObjC:assetId];
    string amountCpp = [self getStringCppFromStringObjC:amount];
    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.addAssetQuantity(accountIdCpp, assetIdCpp, amountCpp);
    return self;
}

-(IRModelTransactionBuilder*)addPeerWithAddress:(NSString*)address
                                  withPublicKey:(IRPublicKey*)peerPublicKey {
    string addressCpp = [self getStringCppFromStringObjC:address];
    NSData *data = [self dataFromHexString:peerPublicKey.value];

    PublicKey publicKeyCpp = PublicKey((char*)([data bytes]));
    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.addPeer(addressCpp, publicKeyCpp);
    return self;
}

-(IRModelTransactionBuilder*)addSignatoryWithAccountId:(NSString*)accountId
                                         withPublicKey:(IRPublicKey*)publicKey {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    NSData *data = [self dataFromHexString:publicKey.value];

    PublicKey publicKeyCpp = PublicKey((char*)([data bytes]));
    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.addSignatory(accountIdCpp, publicKeyCpp);
    return self;
}

-(IRModelTransactionBuilder*)createAccountWithAccountName:(NSString*)accountName
                                             withDomainId:(NSString*)domainId
                                            withPublicKey:(IRPublicKey*)publicKey {
    string accountNameCpp = [self getStringCppFromStringObjC:accountName];
    string domainIdCpp = [self getStringCppFromStringObjC:domainId];
    string publicKeyCpp = [self getStringCppFromStringObjC:publicKey.value];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.createAccount(accountNameCpp,
                                                                domainIdCpp,
                                                                PublicKey(Blob::fromHexString(publicKeyCpp)));
    // NSLog(@"%@", data);
    return self;
}

-(IRModelTransactionBuilder*)setAccountQuorumWithAccountId:(NSString*)accountId
                                                withQuorum:(int)quorum {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.setAccountQuorum(accountIdCpp,
                                                                   quorum);
    return self;
}

-(IRModelTransactionBuilder*)createDomainWithDomainId:(NSString*)domainId
                                      withDefaultRole:(NSString*)defaultRole {
    string domainIdCpp = [self getStringCppFromStringObjC:domainId];
    string defaultRoleCpp = [self getStringCppFromStringObjC:defaultRole];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.createDomain(domainIdCpp,
                                                               defaultRoleCpp);
    return self;
}

-(IRModelTransactionBuilder*)createAssetWithAssetName:(NSString*)assetName
                                         withDomainId:(NSString*)domainId
                                        withPercision:(double)precision {
    string assetNameCpp = [self getStringCppFromStringObjC:assetName];
    string domainIdCpp = [self getStringCppFromStringObjC:domainId];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.createAsset(assetNameCpp,
                                                              domainIdCpp,
                                                              precision);
    return self;
}

-(IRModelTransactionBuilder*)appendRoleToAccountId:(NSString*)accountId
                                      withRoleName:(NSString*)roleName {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string roleNameCpp = [self getStringCppFromStringObjC:roleName];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.appendRole(accountIdCpp,
                                                             roleNameCpp);
    return self;
}

-(IRModelTransactionBuilder*)createRoleWithName:(NSString*)roleName
                                withPermissions:(NSArray*)permissions {
    string roleNameCpp = [self getStringCppFromStringObjC:roleName];
    vector<string> permissionsVectorCpp;

    for (NSString* permission in permissions) {
        string permissionCpp = [self getStringCppFromStringObjC:permission];
        permissionsVectorCpp.push_back(permissionCpp);
    }

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.createRole(roleNameCpp,
                                                             permissionsVectorCpp);
    return self;
}

-(IRModelTransactionBuilder*)detachRoleWithAccountId:(NSString*)accountId
                                        withRoleName:(NSString*)roleName {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string roleNameCpp = [self getStringCppFromStringObjC:roleName];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.detachRole(accountIdCpp,
                                                             roleNameCpp);
    return self;
}

-(IRModelTransactionBuilder*)grantPermissionToAccountId:(NSString*)accountId
                                         withPermission:(NSString*)permission {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string permissionCpp = [self getStringCppFromStringObjC:permission];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.grantPermission(accountIdCpp,
                                                                  permissionCpp);
    return self;
}

-(IRModelTransactionBuilder*)revokePermissionToAccountId:(NSString*)accountId
                                          withPermission:(NSString*)permission {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string permissionCpp = [self getStringCppFromStringObjC:permission];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.revokePermission(accountIdCpp,
                                                                   permissionCpp);
    return self;
}

-(IRModelTransactionBuilder*)setAccountDetailToAccountId:(NSString*)accountId
                                                 withKey:(NSString*)key
                                               withValue:(NSString*)value {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string keyCpp = [self getStringCppFromStringObjC:key];
    string valueCpp = [self getStringCppFromStringObjC:value];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.setAccountDetail(accountIdCpp,
                                                                   keyCpp,
                                                                   valueCpp);
    return self;
}

-(IRModelTransactionBuilder*)subtractAssetQuantityFromAccountId:(NSString*)accountId
                                                    withAssetId:(NSString*)assetId
                                                     withAmount:(NSString*)amount {
    string accountIdCpp = [self getStringCppFromStringObjC:accountId];
    string assetIdCpp = [self getStringCppFromStringObjC:assetId];
    string amountCpp = [self getStringCppFromStringObjC:amount];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.subtractAssetQuantity(accountIdCpp,
                                                                        assetIdCpp,
                                                                        amountCpp);
    return self;
}

-(IRModelTransactionBuilder*)transferAssetFromAccountId:(NSString*)sourceAccountId
                                 toDestinationAccountId:(NSString*)destinationAccountId
                                            withAssetId:(NSString*)assetId
                                        withDescription:(NSString*)description
                                             withAmount:(NSString*)amount {
    string sourceAccountIdCpp = [self getStringCppFromStringObjC:sourceAccountId];
    string destinationAccountIdCpp = [self getStringCppFromStringObjC:destinationAccountId];
    string assetIdCpp = [self getStringCppFromStringObjC:assetId];
    string descriptionCpp = [self getStringCppFromStringObjC:description];
    string amountCpp = [self getStringCppFromStringObjC:amount];

    transactionBuilderImpl->transactionBuilderCpp =
    transactionBuilderImpl->transactionBuilderCpp.transferAsset(sourceAccountIdCpp,
                                                                destinationAccountIdCpp,
                                                                assetIdCpp,
                                                                descriptionCpp,
                                                                amountCpp);
    return self;
}

-(UnsignedTransactionObjC*)build {
    try {
        UnsignedTransactionCpp unsignedTransactionCpp = transactionBuilderImpl->transactionBuilderCpp.build();
        UnsignedTransactionImpl *unsignedTransactionImpl = new UnsignedTransactionImpl(unsignedTransactionCpp);
        UnsignedTransactionObjC *unsignedTransactionObjC = [[UnsignedTransactionObjC alloc] init:unsignedTransactionImpl];
        return unsignedTransactionObjC;
    } catch (const invalid_argument e) {
        NSString* description = [[NSString alloc] initWithUTF8String:e.what()];
        @throw [NSException exceptionWithName:@"Build unsigned transaction exception"
                                       reason:description
                                     userInfo:@{@"Description": description}];
    }
    return [[UnsignedTransactionObjC alloc] init];
}

-(string)getStringCppFromStringObjC:(NSString*)stringObjC {
    string stringCpp = string([stringObjC UTF8String],
                              [stringObjC lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    return stringCpp;
}

- (NSData*)dataFromHexString:(NSString*) string {
    [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData* dataValue = [[NSMutableData alloc] init];
    unsigned char byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length]/2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        byte = strtol(byte_chars, NULL, 16);
        [dataValue appendBytes:&byte length:1];
    }
    return dataValue;
}

@end
