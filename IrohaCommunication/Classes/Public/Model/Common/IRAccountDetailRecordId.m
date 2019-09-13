/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import "IRAccountDetailRecordId.h"


@interface IRAccountDetailRecordId: NSObject <IRAccountDetailRecordId>
@end


@implementation IRAccountDetailRecordId

@synthesize writer = _writer;
@synthesize key = _key;

- (instancetype)initWithWriter:(nonnull NSString *)writer key:(nonnull NSString *)key {
    if (self = [super init]) {
        _writer = writer;
        _key = key;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Writer: %@\nKey:%@", _writer, _key];
}

@end


@implementation IRAccountDetailRecordIdFactory

+ (nullable id<IRAccountDetailRecordId>)accountDetailRecordIdWithWriter:(nonnull NSString *)writer
                                                                    key:(nonnull NSString *)key {
    return [[IRAccountDetailRecordId alloc] initWithWriter:writer key:key];
}

@end
