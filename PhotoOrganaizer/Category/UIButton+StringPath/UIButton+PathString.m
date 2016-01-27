//
//  UIButton+PathString.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/26/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "UIButton+PathString.h"

@implementation UIButton (PathString)

@dynamic pathString;

- (void)setPathString:(NSString *)pathString {
    [self setValue:pathString forKey:@"path"];
}

- (NSString *)pathString {
    return [self valueForKey:@"path"];
}

@end
