//
//  MSValidator.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSValidator : NSObject

+ (BOOL)isPhotoPathExtension:(NSString *)name;

+ (BOOL)checkForSymbolsInString:(NSString *)string;

+ (BOOL)isRootFolders:(NSString *)path;

@end
