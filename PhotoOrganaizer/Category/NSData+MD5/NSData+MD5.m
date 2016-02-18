//
//  NSData+MD5.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/18/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)

//- (NSString *)md5
//{
//    const char* cStr = [self UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(cStr, strlen(cStr), result);
//    
//    static const char HexEncodeChars[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
//    char *resultData = malloc(CC_MD5_DIGEST_LENGTH * 2 + 1);
//    
//    for (uint index = 0; index < CC_MD5_DIGEST_LENGTH; index++) {
//        resultData[index * 2] = HexEncodeChars[(result[index] >> 4)];
//        resultData[index * 2 + 1] = HexEncodeChars[(result[index] % 0x10)];
//    }
//    resultData[CC_MD5_DIGEST_LENGTH * 2] = 0;
//    
//    NSString *resultString = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
//    free(resultData);
//    
//    return resultString;
//}

- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}

@end
