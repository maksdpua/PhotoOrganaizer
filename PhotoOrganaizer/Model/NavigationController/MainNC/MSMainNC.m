//
//  MSMainNC.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSMainNC.h"
#import "LoginService.h"
#import "MSMainVC.h"
#import "MSAuth.h"
#import "MSFolderViewer.h"
#import "AuthConstants.h"
#import "MSGalleryRoll.h"
#import "MSGalleryRollNavigation.h"

@interface MSMainNC ()



@end

@implementation MSMainNC {
    NSMutableArray *arrayVC;
    MSFolderViewer *folderViewer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBlurEffect];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewFolder) name:kTokenWasAccepted object:nil];
    MSMainVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVC class])];
    arrayVC = [NSMutableArray new];
    [arrayVC addObject:mainVC];
    folderViewer = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
    if ([MSAuth token]) {
        [arrayVC addObject:folderViewer];
    }
    if ([MSAuth defaulFolderPath]) {
        MSGalleryRoll *galleryRoll = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRoll class])];
        [arrayVC addObject:galleryRoll];
    }
    [self setViewControllers:arrayVC animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)pushViewFolder {
    [arrayVC addObject:folderViewer];
    [self setViewControllers:arrayVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addBlurEffect {
    // Add blur view
    CGRect bounds = self.navigationController.navigationBar.bounds;
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationController.navigationBar addSubview:visualEffectView];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar sendSubviewToBack:visualEffectView];
    
    // Here you can add visual effects to any UIView control.
    // Replace custom view with navigation bar in above code to add effects to custom view.
}

@end
