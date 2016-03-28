//
//  MSPhoto.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MSFolder;

NS_ASSUME_NONNULL_BEGIN

@interface MSPhoto : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)checkForBackFolderAndAddWith:(NSString *)path photoObject:(MSPhoto *)object;

@end

NS_ASSUME_NONNULL_END

#import "MSPhoto+CoreDataProperties.h"
