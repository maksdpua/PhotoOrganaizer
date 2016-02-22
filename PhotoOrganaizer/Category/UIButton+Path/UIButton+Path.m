//
//  UIButton+Path.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/22/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "UIButton+Path.h"

@implementation UIButton (Path)

@dynamic path;

- (void)setPath:(NSString *)path {
    [self.path setValue:path forKey:@"path"];
}

- (NSString *)path {
    return [self.path valueForKey:@"path"];
}

@end
