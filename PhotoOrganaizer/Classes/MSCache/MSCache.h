//
//  MSCache.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/5/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSPhoto.h"

@interface MSCache : NSObject

- (void)cacheForImageWithKey:(MSPhoto *)photo completeBlock:(void(^)(NSData *responseData))complete errorBlock:(void(^)(NSError *error))fail;

@end
