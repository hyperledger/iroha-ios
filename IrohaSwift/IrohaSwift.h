//
//  IrohaSwift.h
//  IrohaSwift
//
//  Created by Kaji Satoshi on 2016/09/18.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for IrohaSwift.
FOUNDATION_EXPORT double IrohaSwiftVersionNumber;

//! Project version string for IrohaSwift.
FOUNDATION_EXPORT const unsigned char IrohaSwiftVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IrohaSwift/PublicHeader.h>

char* base64_encode(unsigned char const* bytes_to_encode, unsigned int in_len);

unsigned char* base64_decode(const char* encoded_string);

void sha3_256(const unsigned char *message, size_t message_len, unsigned char *out);

int ed25519_create_seed(unsigned char *seed);

void ed25519_sign(unsigned char *signature, const unsigned char *message, size_t message_len, const unsigned char *public_key, const unsigned char *private_key);

void ed25519_create_keypair(unsigned char *public_key, unsigned char *private_key, const unsigned char *seed);

int ed25519_verify(const unsigned char *signature, const unsigned char *message, size_t message_len, const unsigned char *public_key);
