//
//  MSValidator.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSValidator.h"

@implementation MSValidator

+ (BOOL)isPhotoPathExtension:(NSString *)name {
    
    NSArray *arrayOfPhotosFilePath = @[@"png",@"jpeg",@"jpg"];
    for (NSString* photoFilePath in arrayOfPhotosFilePath) {
        if ([photoFilePath isEqualToString:[name pathExtension]]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)checkForSymbolsInString:(NSString *)string {
    NSString *checkString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([checkString length]>0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isRootFolders:(NSString *)path {
    return YES;
}

@end
