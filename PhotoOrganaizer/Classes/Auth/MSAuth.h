//
//  MSAuth.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/10/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAuth : NSObject

+ (void)beginObservingForAuthData;
+ (NSString *)token;
+ (NSString *)uid;

@end
