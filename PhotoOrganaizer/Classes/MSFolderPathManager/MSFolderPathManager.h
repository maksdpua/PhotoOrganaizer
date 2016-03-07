//
//  MSFolderPathManager.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSFolderPathManager : NSObject

+ (instancetype)sharedManager;

- (void)addEnteredFolderPath:(NSString *)folderPath;

- (NSString *)getLastPathInArray;

- (void)removeLastPathInArray;

@end
