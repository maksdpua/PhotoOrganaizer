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
static NSString *const kRoot = @"root";


@implementation MSFolder

- (NSDictionary *)dictionaryInstructionManager {
    return @{kName : kNameOfFolder, kDotTag : kTag, kID : kIdFolder, kPathLower : kPath};
}

- (instancetype)initClassWithDictionary:(NSDictionary *)dictionary {
    [self checkOrCreateRootFolderEntity];
    for (NSDictionary *element in [dictionary valueForKey:@"entries"]) {
        if ([[element valueForKey:kDotTag] isEqualToString:@"folder"]) {
            NSString *pathString = [NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]];
            id obj = [self.class MR_findFirstByAttribute:kPath withValue:pathString];
            if (obj) {
                self = obj;
            } else {
                self = [self.class MR_createEntity];
                self = [super loadClassWithDictionary:element InstructionDictionary:[self dictionaryInstructionManager]];
                [self checkForBackFolderAndAddWith:self.path photoObject:nil];
            }
        } else if ([[element valueForKey:kDotTag] isEqualToString:@"file"]){
            if ([MSValidator isPhotoPathExtension:[element valueForKey:kName]] && ![MSPhoto MR_findFirstByAttribute:kPath withValue:[NSString stringWithFormat:@"%@", [element valueForKey:kPathLower]]]) {
                MSPhoto *photo = [[MSPhoto alloc]initClassWithDictionary:element];
                [self checkForBackFolderAndAddWith:photo.path photoObject:photo];
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

- (void)checkForBackFolderAndAddWith:(NSString *)path photoObject:(MSPhoto *)object {
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    if (pathArray.count>2) {
        NSMutableArray *backFolderPathArray = [NSMutableArray new];
        [backFolderPathArray addObjectsFromArray:pathArray];
        [backFolderPathArray removeLastObject];
        NSString *backFolderPath = [backFolderPathArray componentsJoinedByString:@"/"];
        if (object) {
            [[MSFolder MR_findFirstByAttribute:kPath withValue:backFolderPath] addPhotosObject:object];
        } else {
            [[MSFolder MR_findFirstByAttribute:kPath withValue:backFolderPath] addFoldersObject:self];
        }
    } else {
        if (object) {
            [[MSFolder MR_findFirstByAttribute:kIdFolder withValue:kRoot] addPhotosObject:object];
        } else {
           [[MSFolder MR_findFirstByAttribute:kIdFolder withValue:kRoot] addFoldersObject:self];
        }
        
    }
}

- (void)checkOrCreateRootFolderEntity {
    if (![self.class MR_findFirstByAttribute:kIdFolder withValue:kRoot]) {
        MSFolder *root = [self.class MR_createEntity];
        [root setValue:kRoot forKey:kIdFolder];
        [root setValue:kRoot forKey:kNameOfFolder];
        [root setValue:@"" forKey:kPath];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

@end
