//
//  MSValidator.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSValidator.h"

@implementation MSValidator

+ (BOOL)checkForSymbolsInString:(NSString *)string {
    NSString *checkString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([checkString length]>0) {
        return YES;
    } else {
        return NO;
    }
}

@end
