//
//  MSFolderNewFolderView.h
//  PhotoOrganaizer
//
//  Created by Maks on 2/16/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSOptionsView.h"

@protocol MSCreateNewFolderDelegate;

@interface MSCreateNewFolderView : UIView

@property (nonatomic, weak)id <MSCreateNewFolderDelegate>delegate;

- (instancetype)initOnView:(UIView *)view andPath:(NSString *)path;

@end

@protocol MSCreateNewFolderDelegate <NSObject>

- (void)reloadDataAfterDismissCreateFolderView;

@end


