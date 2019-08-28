/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRGetPeers.h"
#import "Queries.pbobjc.h"

@implementation IRGetPeers


#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetPeers *query = [GetPeers new];
    
    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getPeers = query;
    
    return payload;
}

@end
