//
//  MSBlurEffect.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/6/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSBlurEffect.h"
#import <objc/runtime.h>

@interface UIBlurEffect (Protected)
@property (nonatomic, readonly) id effectSettings;
@end


@implementation MSBlurEffect

+ (instancetype)effectWithStyle:(UIBlurEffectStyle)style
{
    id result = [super effectWithStyle:style];
    object_setClass(result, self);
    
    return result;
}

- (id)effectSettings
{
    id settings = [super effectSettings];
    [settings setValue:@5 forKey:@"blurRadius"];
    return settings;
}

- (id)copyWithZone:(NSZone*)zone
{
    id result = [super copyWithZone:zone];
    object_setClass(result, [self class]);
    return result;
}

@end

