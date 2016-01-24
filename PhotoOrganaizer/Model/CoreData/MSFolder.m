//
//  MSFolder.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/23/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolder.h"
#import "MSPhoto.h"

static NSString *const kNameOfFolder = @"nameOfFolder";
static NSString *const kIdFolder = @"idFolder";


@implementation MSFolder

- (NSDictionary *)dictionaryInstructionManager {
    return @{kName : kNameOfFolder, kDotTag : kTag, kID : kIdFolder, kPathLower : kPath};
}

- (instancetype)initClassWithDictionary:(NSDictionary *)dictionary {
    for (NSDictionary *element in [dictionary valueForKey:@"entries"]) {
        if ([[element valueForKey:kDotTag] isEqualToString:@"folder"]) {
            NSString *pathString = [NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]];
            
            id obj = [self.class MR_findFirstByAttribute:kPath withValue:pathString];
            if (obj) {
                self = obj;
            } else {
                self = [MSFolder MR_createEntity];
                self = [super loadClassWithDictionary:element InstructionDictionary:[self dictionaryInstructionManager]];
                NSArray *pathArray = [self.path componentsSeparatedByString:@"/"];
                if (pathArray.count>2) {
                    NSString *backFolderPath = [self.path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",[pathArray lastObject]] withString:@""];
                    [[MSFolder MR_findFirstByAttribute:kPath withValue:backFolderPath] addFoldersObject:self];
                }
            }
        } else if ([[element valueForKey:kDotTag] isEqualToString:@"file"]){
            if ([MSValidator isPhotoPathExtension:[element valueForKey:kName]] && ![MSPhoto MR_findFirstByAttribute:kPath withValue:[NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]]]) {
                MSPhoto *photo = [[MSPhoto alloc]initClassWithDictionary:element];
                NSArray *pathArray = [self.path componentsSeparatedByString:@"/"];
                if (pathArray.count>2) {
                    NSString *backFolderPath = [self.path stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",[pathArray lastObject]] withString:@""];
                    [[self.class MR_findFirstByAttribute:kPath withValue:backFolderPath] addPhotosObject:photo];
                }
            }
        } else if ([[element valueForKey:kDotTag] isEqualToString:@"deleted"]){
            if ([self.class MR_findFirstByAttribute:kPath withValue:[NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]]]) {
                [[self.class MR_findFirstByAttribute:kPath withValue:[NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]]] MR_deleteEntity];
            } else if ([MSPhoto MR_findFirstByAttribute:kPath withValue:[NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]]]) {
                [[MSPhoto MR_findFirstByAttribute:kPath withValue:[NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]]] MR_deleteEntity];
            }
            
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return self;
}

@end
