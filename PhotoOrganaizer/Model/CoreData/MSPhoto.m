//
//  MSPhoto.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSPhoto.h"
#import "MSFolder.h"

@implementation MSPhoto

- (NSDictionary *)dictionaryInstructionManager {
    return @{@"name" : @"namePhoto", @".tag" : @"tag", @"id" : @"idPhoto", @"path_lower" : @"path", @"size" : @"sizePhoto", @"server_modified" : @"serverModified", @"client_modified" : @"clientModified", @"rev" : @"revPhoto"};
}

@end
