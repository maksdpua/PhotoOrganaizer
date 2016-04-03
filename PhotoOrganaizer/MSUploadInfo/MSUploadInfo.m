//
//  MSUploadInfo.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/3/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSUploadInfo.h"

@implementation MSUploadInfo

- (id)copyWithZone:(NSZone *)zone {
    MSUploadInfo *info = [[[self class] allocWithZone:zone]init];
    info.path = [_path copyWithZone:zone];
    info.data = [_data copyWithZone:zone];
    info.status = _status;
    info.progress = _progress;
    info.size = _size;
    
    return info;
}

@end
