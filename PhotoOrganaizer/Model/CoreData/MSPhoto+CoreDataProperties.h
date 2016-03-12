//
//  MSPhoto+CoreDataProperties.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MSPhoto.h"
#import "MSThumbnail.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSPhoto (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *namePhoto;
@property (nullable, nonatomic, retain) NSString *path;
@property (nullable, nonatomic, retain) NSString *idPhoto;
@property (nullable, nonatomic, retain) NSString *sizePhoto;
@property (nullable, nonatomic, retain) NSDate *serverModified;
@property (nullable, nonatomic, retain) NSString *revPhoto;
@property (nullable, nonatomic, retain) NSDate *clientModified;
@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) MSFolder *toFolder;
@property (nullable, nonatomic, retain) MSThumbnail *imageThumbnail;


@end

@interface MSPhoto (CoreDataGeneratedAccessors)

- (void)addImageThumbnailObject:(MSThumbnail *)value;
- (void)removeImageThumbnailObject:(MSThumbnail *)value;



@end



NS_ASSUME_NONNULL_END
