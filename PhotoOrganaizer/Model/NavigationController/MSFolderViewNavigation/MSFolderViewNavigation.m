//
//  MSFolderViewNavigation.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/17/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderViewNavigation.h"
#import "MSGalleryRoll.h"

@interface MSFolderViewNavigation ()

@end

@implementation MSFolderViewNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *leftSw[[UITapGestureRecognizer alloc] addTarget:self action:@selector(didSwipeLeft:)];
}

- (void)didSwipeLeft:(UITapGestureRecognizer *)swipe {
    [UIView animateWithDuration:0 animations:^{
        MSGalleryRoll *galleryRoll = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRoll class])];
                                      [self.view addSubview:galleryRoll];
        
                                      } completion:^(BOOL finished) {
                                          
                                      }];
    }

@end
