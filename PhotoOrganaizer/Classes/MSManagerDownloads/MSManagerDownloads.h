//
//  MSManagerDownloads.h
//  PhotoOrganaizer
//
//  Created by Maks on 4/3/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION = @"MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION";

@interface MSManagerDownloads : NSObject

+ (instancetype)sharedManager;

- (void)addNewPath:(NSArray <NSString *> *)path;

@end
