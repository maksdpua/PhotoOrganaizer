//
//  MSFolderNewFolderView.h
//  PhotoOrganaizer
//
//  Created by Maks on 2/16/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSCreateNewFolderDelegate;

@interface MSCreateNewFolderView : UIView

@property (nonatomic, weak)id<MSCreateNewFolderDelegate>delegate;

- (instancetype)initOnView:(UIView *)view;

@end

@protocol MSCreateNewFolderDelegate <NSObject>

@required

- (void)createFolderWithName:(NSString *)name;

@end
