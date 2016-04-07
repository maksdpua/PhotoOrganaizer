//
//  MSFolderViewerDataSource.h
//  PhotoOrganaizer
//
//  Created by Maks on 4/6/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFolder.h"

@protocol MSFolderViewerDataSourceDelegate;

@interface MSFolderViewerDataSource : NSObject

@property (nonatomic, weak) id<MSFolderViewerDataSourceDelegate>delegate;

- (instancetype)initWithDelegate:(id<MSFolderViewerDataSourceDelegate>)delegate;

- (NSUInteger)countOfModels;
- (MSFolder *)modelAtIndex:(NSInteger)index;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;

@end

@protocol MSFolderViewerDataSourceDelegate <NSObject>

@optional

- (void)contentWasChanged;

@end
