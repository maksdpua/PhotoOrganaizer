//
//  MSManagerDownloads.h
//  PhotoOrganaizer
//
//  Created by Maks on 4/3/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSUploadInfo.h"

static NSString * const MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION = @"MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION";

@interface MSManagerDownloads : NSObject

+ (instancetype)sharedManager;

- (void)addNewImageInfo:(NSArray <NSDictionary *> *)imageInfo ;

- (NSUInteger)modelsCount;

- (MSUploadInfo *)uploadModelAtIndex:(NSUInteger)index;

@end
