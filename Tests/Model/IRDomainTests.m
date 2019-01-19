@import XCTest;
@import IrohaCommunication;

static const NSUInteger VALID_DOMAINS_COUNT = 5;
static NSString * const VALID_DOMAINS[] = {
    @"g",
    @"gmail.com",
    @"g1mail.com",
    @"g1-mail.com.g1-mail.com.g1mail.com.g1mail.com.g1-mail.com",
    @"g1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailL.com"
};

static const NSUInteger INVALID_DOMAINS_COUNT = 5;
static NSString * const INVALID_DOMAINS[] = {
    @"",
    @"1gmail.com",
    @"g_mail.com",
    @"gmail.",
    @"g1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailLg1mail.com"
};

@interface IRDomainTests : XCTestCase

@end

@implementation IRDomainTests

- (void)testValidDomains {
    for (NSUInteger i = 0; i < VALID_DOMAINS_COUNT; i++) {
        id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:VALID_DOMAINS[i]
                                                               error:nil];
        XCTAssertNotNil(domain);
        XCTAssertEqualObjects([domain identifier], VALID_DOMAINS[i]);
    }
}

- (void)testInvalidDomainsWithError {
    for (NSUInteger i = 0; i < INVALID_DOMAINS_COUNT; i++) {
        NSError *error;
        id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:INVALID_DOMAINS[i]
                                                               error:&error];
        XCTAssertNil(domain);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidDomainIdentifier);
    }
}

- (void)testInvalidDomainsWithoutError {
    for (NSUInteger i = 0; i < INVALID_DOMAINS_COUNT; i++) {
        id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:INVALID_DOMAINS[i]
                                                               error:nil];
        XCTAssertNil(domain);
    }
}

@end
