//
//  MSGalleryRollDataSource.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/27/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSPhoto.h"

@protocol MSGalleryRollDataSourceDelegate;

@interface MSGalleryRollDataSource : NSObject

@property (nonatomic, weak) id<MSGalleryRollDataSourceDelegate>delegate;

- (instancetype)initWithDelegate:(id<MSGalleryRollDataSourceDelegate>)delegate;
- (NSUInteger)countOfModels;
- (MSPhoto *)modelAtIndex:(NSInteger)index;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;
- (void)addNewObjectsWithArray:(NSMutableArray *)objectsArray;

@end

@protocol MSGalleryRollDataSourceDelegate <NSObject>

@optional

- (void)contentWasChanged;

- (void)uploadDataToServer;

@end