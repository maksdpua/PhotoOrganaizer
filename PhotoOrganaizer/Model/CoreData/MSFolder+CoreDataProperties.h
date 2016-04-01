//
//  MSFolder+CoreDataProperties.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/23/16.
//  Copyright © 2016 Maks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MSFolder.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSFolder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *idFolder;
@property (nullable, nonatomic, retain) NSString *nameOfFolder;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) NSSet<MSFolder *> *folders;
@property (nullable, nonatomic, retain) NSSet<MSPhoto *> *photos;
@property (nullable, nonatomic, retain) MSFolder *folder;


@end

@interface MSFolder (CoreDataGeneratedAccessors)

- (void)addFoldersObject:(MSFolder *)value;
- (void)removeFoldersObject:(MSFolder *)value;
- (void)addFolders:(NSSet<MSFolder *> *)values;
- (void)removeFolders:(NSSet<MSFolder *> *)values;

- (void)addPhotosObject:(MSPhoto *)value;
- (void)removePhotosObject:(MSPhoto *)value;
- (void)addPhotos:(NSSet<MSPhoto *> *)values;
- (void)removePhotos:(NSSet<MSPhoto *> *)values;


@end

NS_ASSUME_NONNULL_END
