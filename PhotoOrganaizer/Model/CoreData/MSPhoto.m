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
        NSLog(@"GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    }
    self = [super loadClassWithDictionary:dictionary InstructionDictionary:[self dictionaryInstructionManager]];
    [self checkForBackFolderAndAddWith:self.path photoObject:self];
    
    return self;
}

- (void)checkForBackFolderAndAddWith:(NSString *)path photoObject:(MSPhoto *)object {
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    if (pathArray.count>2) {
        NSMutableArray *backFolderPathArray = [NSMutableArray new];
        [backFolderPathArray addObjectsFromArray:pathArray];
        [backFolderPathArray removeLastObject];
        NSString *backFolderPath = [backFolderPathArray componentsJoinedByString:@"/"];
        if (object) {
            [[MSFolder MR_findFirstByAttribute:kPath withValue:backFolderPath] addPhotosObject:object];
        }
    } else {
        if (object) {
            [[MSFolder MR_findFirstByAttribute:@"idFolder" withValue:@"root"] addPhotosObject:object];
        }

    }
}

@end
