#import "IRBlockQueryResponse+Proto.h"
#import "QryResponses.pbobjc.h"
#import "IRBlock+Proto.h"

@implementation IRBlockQueryResponse (Proto)

+ (nullable IRBlockQueryResponse*)responseFromPbResponse:(nonnull BlockQueryResponse*)queryResponse
                                                   error:(NSError*_Nullable*_Nullable)error {
    if (queryResponse.responseOneOfCase == BlockQueryResponse_Response_OneOfCase_BlockResponse) {
        Block *pbBlock = queryResponse.blockResponse.block;
        if (!pbBlock) {
            if (error) {
                *error = [IRBlockQueryResponse errorWithMessage:@"Unexpected nil protobuf block found."];
            }
            return nil;
        }

        id<IRBlock> block = [IRBlock blockFromPbBlock:pbBlock error:error];
        return [[IRBlockQueryResponse alloc] initWithBlock:block];
    }

    if (queryResponse.responseOneOfCase == BlockQueryResponse_Response_OneOfCase_BlockErrorResponse) {
        NSString *message = queryResponse.blockErrorResponse.message ? queryResponse.blockErrorResponse.message : @"";
        NSError *blockError = [NSError errorWithDomain:NSStringFromClass([IRBlockQueryResponse class])
                                                  code:0
                                              userInfo:@{NSLocalizedDescriptionKey: message}];

        return [[IRBlockQueryResponse alloc] initWithError:blockError];
    }

    if (error) {
        *error = [IRBlockQueryResponse errorWithMessage:@"Both protobuf block and error can't be nil."];
    }

    return nil;
}

#pragma mark - Helper

+ (nonnull NSError*)errorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([IRBlockQueryResponse class])
                               code:IRBlockQueryResponseProtoErrorInvalidField
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
