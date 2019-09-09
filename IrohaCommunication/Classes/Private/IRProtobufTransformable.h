/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef IRSerializable_h
#define IRSerializable_h

@protocol IRProtobufTransformable <NSObject>

- (nullable id)transform:(NSError *_Nullable*_Nullable)error;

@end

#endif
