//
//  MSUploadInfo.h
//  PhotoOrganaizer
//
//  Created by Maks on 4/3/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Wait = 0,
    InProgress = 1,
    Completed = 2
} StatusType;

@interface MSUploadInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic) StatusType status;

@property (nonatomic) float progress;
@property (nonatomic) float size;

@end
