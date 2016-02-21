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
#import "MSFolderViewNavigation.h"

@interface MSMainNC ()

@end

@implementation MSMainNC {
    NSMutableArray *arrayVC;
    MSFolderViewer *folderViewer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentFolderViewerNavigation) name:kTokenWasAccepted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentFolderViewerNavigation) name:kDefaultFolderPath object:nil];
    }

- (void)viewDidAppear:(BOOL)animated {
    if ([MSAuth defaulFolderPath]) {
//        [self presentMSGalleryRollNavigation];
        [self presentFolderViewerNavigation];
    } else if ([MSAuth token]) {
        [self presentFolderViewerNavigation];
    }
}

- (void)presentMSGalleryRollNavigation {
    MSGalleryRollNavigation *galleryRoll = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRollNavigation class])];
    [self presentViewController:galleryRoll animated:YES completion:nil];
}

- (void)presentFolderViewerNavigation {
    MSFolderViewNavigation *folderNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewNavigation class])];
    [self presentViewController:folderNavigation animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
