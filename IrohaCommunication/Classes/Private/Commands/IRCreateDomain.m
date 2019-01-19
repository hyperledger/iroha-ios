#import "IRCreateDomain.h"
#import "Commands.pbobjc.h"

@implementation IRCreateDomain
@synthesize domainId = _domainId;
@synthesize defaultRole = _defaultRole;

- (nonnull instancetype)initWithDomain:(nonnull id<IRDomain>)domain
                           defaultRole:(nullable id<IRRoleName>)defaultRole {

    if (self = [super init]) {
        _domainId = domain;
        _defaultRole = defaultRole;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    CreateDomain *createDomain = [[CreateDomain alloc] init];
    createDomain.domainId = [_domainId identifier];
    createDomain.defaultRole = [_defaultRole value];

    Command *command = [[Command alloc] init];
    command.createDomain = createDomain;

    return command;
}

@end
