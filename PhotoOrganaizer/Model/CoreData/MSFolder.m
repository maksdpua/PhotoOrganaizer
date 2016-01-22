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

- (NSDictionary *)dictionaryInstructionManager {
    return @{@"name" : @"nameOfFolder", @".tag" : @"tag", @"id" : @"idFolder", @"path_lower" : @"path"};
}

- (instancetype)initClassWithDictionary:(NSDictionary *)dictionary {
    for (NSDictionary *element in [dictionary valueForKey:@"entries"]) {
        if ([[element valueForKey:@".tag"] isEqualToString:@"folder"]) {
            NSString *folderIdString = [NSString stringWithFormat:@"%@", [element valueForKey:@"id"]];
            
            id obj = [MSFolder MR_findFirstByAttribute:@"idFolder" withValue:folderIdString];
            if (obj) {
                self = obj;
            } else {
                self = [MSFolder MR_createEntity];
                self = [super loadClassWithDictionary:element InstructionDictionary:[self dictionaryInstructionManager]];
                NSArray *pathArray = [self.path componentsSeparatedByString:@"/"];
                if (pathArray.count>2) {
                    NSString *nameContentFolder = [pathArray objectAtIndex:pathArray.count-2];
//                    [[MSFolder MR_findFirstByAttribute:@"path" withValue:[NSString stringWithFormat:@"/%@", nameContentFolder]] addFoldersObject:self];
                    NSLog(@"%@", nameContentFolder);
                }
//                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
            
            
            
            
        } else {
            
//            if ([MSValidator isPhotoPathExtension:[element valueForKey:@"name"]]) {
//                
//            }
        }
    }
    
    
    return self;
}

@end
