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
    return @{kName : @"namePhoto", kDotTag : @"tag", kID : @"idPhoto", kPathLower : kPath, @"size" : @"sizePhoto", @"server_modified" : @"serverModified", @"client_modified" : @"clientModified", @"rev" : @"revPhoto"};
}

- (instancetype)initClassWithDictionary:(NSDictionary *)dictionary {
    NSString *pathString = [NSString stringWithFormat:@"%@", [dictionary valueForKey:kPathLower]];
    
    id obj = [self.class MR_findFirstByAttribute:kPath withValue:pathString];
    if (obj) {
        self = obj;
    } else {
        self = [self.class MR_createEntity];
        self = [super loadClassWithDictionary:dictionary InstructionDictionary:[self dictionaryInstructionManager]];
        
        [self setValue:[NSString stringWithFormat:@"%@", [[[[dictionary valueForKey:@"media_info"] valueForKey:@"metadata"] valueForKey:@"dimensions"] valueForKey:@"height"]] forKey:@"height"];
        [self setValue:[NSString stringWithFormat:@"%@", [[[[dictionary valueForKey:@"media_info"] valueForKey:@"metadata"] valueForKey:@"dimensions"] valueForKey:@"width"]] forKey:@"width"];

    }
    
    return self;
}

@end
