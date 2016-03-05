//
//  MSThumbnail+CoreDataProperties.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/5/16.
//  Copyright © 2016 Maks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MSThumbnail.h"
@class MSPhoto;

NS_ASSUME_NONNULL_BEGIN

@interface MSThumbnail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, retain) MSPhoto *toPhoto;

@end

NS_ASSUME_NONNULL_END
