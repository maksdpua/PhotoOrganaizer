//
//  MSFolder.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolder.h"
#import "MSPhoto.h"

@implementation MSFolder

- (instancetype)initClassWithDictionary:(NSDictionary *)dictionary {
    for (NSDictionary *element in [dictionary valueForKey:@"entries"]) {
        if ([[element valueForKey:@"name"] hasPrefix:@".jpg"]) {
            
        }
    }
    
    return self;
}

@end
