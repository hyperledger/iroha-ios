#import "NSDate+IrohaCommunication.h"

@implementation NSDate (IrohaCommunication)

- (UInt64)milliseconds {
    return (UInt64)([self timeIntervalSince1970] * 1000);
}

+ (nonnull instancetype)dateWithTimestampInMilliseconds:(UInt64)milliseconds {
    return [NSDate dateWithTimeIntervalSince1970:milliseconds / 1000.0];
}

@end
