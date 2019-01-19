#import "IRTransactionBuilder.h"
#import "IRCommandAll.h"
#import "IRTransactionImpl.h"

static const NSUInteger DEFAULT_QUORUM = 1;

@interface IRTransactionBuilder()

@property(strong, nonatomic)id<IRAccountId> accountId;
@property(strong, readwrite)NSDate *date;
@property(nonatomic, readwrite)NSUInteger quorum;
@property(strong, nonatomic)NSMutableArray<id<IRCommand>> *commands;

@end

@implementation IRTransactionBuilder

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];

    if (self) {
        _quorum = DEFAULT_QUORUM;
        _commands = [NSMutableArray array];
    }

    return self;
}

#pragma mark - Commands

+ (nonnull instancetype)builderWithCreatorAccountId:(nonnull id<IRAccountId>)creator {
    return [[[IRTransactionBuilder alloc] init] withCreatorAccountId:creator];
}

- (nonnull instancetype)addAssetQuantity:(nonnull id<IRAssetId>)assetId
                                  amount:(nonnull id<IRAmount>)amount {

    IRAddAssetQuantity *command = [[IRAddAssetQuantity alloc] initWithAssetId:assetId
                                                                       amount:amount];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)subtractAssetQuantity:(nonnull id<IRAssetId>)assetId
                                       amount:(nonnull id<IRAmount>)amount {

    IRSubtractAssetQuantity *command = [[IRSubtractAssetQuantity alloc] initWithAssetId:assetId
                                                                                 amount:amount];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)addPeer:(nonnull id<IRAddress>)address
                      publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {

    IRAddPeer *command = [[IRAddPeer alloc] initWithAddress:address
                                                  publicKey:publicKey];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)addSignatory:(nonnull id<IRAccountId>)accountId
                           publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {

    IRAddSignatory *command = [[IRAddSignatory alloc] initWithAccountId:accountId
                                                              publicKey:publicKey];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)removeSignatory:(nonnull id<IRAccountId>)accountId
                              publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {

    IRRemoveSignatory *command = [[IRRemoveSignatory alloc] initWithAccountId:accountId
                                                                    publicKey:publicKey];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)appendRole:(nonnull id<IRAccountId>)accountId
                          roleName:(nonnull id<IRRoleName>)roleName {

    IRAppendRole *command = [[IRAppendRole alloc] initWithAccountId:accountId
                                                           roleName:roleName];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)createAccount:(nonnull id<IRAccountId>)accountId
                            publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {

    IRCreateAccount *command = [[IRCreateAccount alloc] initWithAccountId:accountId
                                                                publicKey:publicKey];;

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)createAsset:(nonnull id<IRAssetId>)assetId
                          precision:(UInt32)precision {

    IRCreateAsset *command = [[IRCreateAsset alloc] initWithAssetId:assetId
                                                          precision:precision];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)createDomain:(nonnull id<IRDomain>)domainId
                         defaultRole:(nonnull id<IRRoleName>)defaultRole {

    IRCreateDomain *command = [[IRCreateDomain alloc] initWithDomain:domainId
                                                         defaultRole:defaultRole];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)createRole:(nonnull id<IRRoleName>)roleName
                       permissions:(nonnull NSArray<id<IRRolePermission>>*)permissions {

    IRCreateRole *command = [[IRCreateRole alloc] initWithRoleName:roleName
                                                       permissions:permissions];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)detachRole:(nonnull id<IRAccountId>)accountId
                          roleName:(nonnull id<IRRoleName>)roleName {

    IRDetachRole *command = [[IRDetachRole alloc] initWithAccountId:accountId
                                                           roleName:roleName];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)grantPermission:(nonnull id<IRAccountId>)accountId
                             permission:(nonnull id<IRGrantablePermission>)grantablePermission {

    IRGrantPermission *command = [[IRGrantPermission alloc] initWithAccountId:accountId
                                                                   permission:grantablePermission];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)revokePermission:(nonnull id<IRAccountId>)accountId
                              permission:(nonnull id<IRGrantablePermission>)grantablePermission {

    IRRevokePermission *command = [[IRRevokePermission alloc] initWithAccountId:accountId
                                                                     permission:grantablePermission];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)setAccountDetail:(nonnull id<IRAccountId>)accountId
                                     key:(nonnull NSString*)key
                                   value:(nonnull NSString*)value {

    IRSetAccountDetail *command = [[IRSetAccountDetail alloc] initWithAccountId:accountId
                                                                            key:key
                                                                          value:value];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)setAccountQuorum:(nonnull id<IRAccountId>)accountId
                                  quorum:(UInt32)quorum {

    IRSetAccountQuorum *command = [[IRSetAccountQuorum alloc] initWithAccountId:accountId
                                                                         quorum:quorum];

    [self addCommand:command];

    return self;
}

- (nonnull instancetype)transferAsset:(nonnull id<IRAccountId>)sourceAccountId
                   destinationAccount:(nonnull id<IRAccountId>)destinationAccountId
                              assetId:(nonnull id<IRAssetId>)assetId
                          description:(nonnull NSString*)transferDescription
                               amount:(nonnull id<IRAmount>)amount {

    IRTransferAsset *command = [[IRTransferAsset alloc] initWithSourceAccountId:sourceAccountId
                                                           destinationAccountId:destinationAccountId
                                                                        assetId:assetId
                                                            transferDescription:transferDescription
                                                                         amount:amount];

    [self addCommand:command];

    return self;
}

#pragma mark - Protocol

- (nonnull instancetype)withCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId {
    _accountId = creatorAccountId;
    
    return self;
}

- (nonnull instancetype)withCreatedDate:(nonnull NSDate*)date {
    _date = date;

    return self;
}

- (nonnull instancetype)withQuorum:(NSUInteger)quorum {
    _quorum = quorum;

    return self;
}

- (nonnull instancetype)addCommand:(nonnull id<IRCommand>)command {
    [_commands addObject: command];

    return self;
}

- (nullable id<IRTransaction>)build:(NSError*_Nullable*_Nullable)error {
    if (!_accountId) {
        if (error) {
            NSString *message = @"Creator's account id is required!";
            *error = [NSError errorWithDomain:NSStringFromClass([IRTransactionBuilder class])
                                        code:IRTransactionBuilderErrorMissingCreator
                                    userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSDate *createdAt = _date ? _date : [NSDate date];

    IRTransaction *transaction = [[IRTransaction alloc] initWithCreatorAccountId:_accountId
                                                                       createdAt:createdAt
                                                                        commands:_commands
                                                                          quorum:_quorum
                                                                      signatures:nil
                                                                     batchHashes:nil
                                                                       batchType:IRTransactionBatchTypeNone];

    return transaction;
}

@end
