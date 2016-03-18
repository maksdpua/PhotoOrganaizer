//
//  MSFolderViewNavigation.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/17/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderViewNavigation.h"
#import "MSGalleryRoll.h"
#import "MSGalleryRollNavigation.h"
#import "MSAuth.h"
#import "MSMainVC.h"
#import "MSFolder.h"

@interface MSFolderViewNavigation ()<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat firstX;

@end

@implementation MSFolderViewNavigation {
    MSGalleryRollNavigation *galleryRollNavigation;
    MSMainVC *loginViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToFolderViewer) name:kTokenWasAccepted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"logout" object:nil];
    loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSMainVC class])];
    if ([MSAuth token]) {
        [self addPanRecognizer];
    } else {
        [[MSFolder MR_findFirstByAttribute:@"nameOfFolder" withValue:@"root"] MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            [self hideNavBarAndToolBar:YES];
            [self pushViewController:loginViewController animated:NO];
        }];
        
    }
}

- (void)hideNavBarAndToolBar:(BOOL)yesOrNo {
    [self.navigationBar setHidden:yesOrNo];
    [self.toolbar setHidden:yesOrNo];
}

- (void)backToFolderViewer {
    [self addPanRecognizer];
    [self hideNavBarAndToolBar:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadFolderViewer" object:nil];
    [self popToRootViewControllerAnimated:YES];
    
}

- (void)addPanRecognizer {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)didSwipeLeft:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        galleryRollNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRollNavigation class])];
        
        galleryRollNavigation.view.frame = CGRectMake(CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(galleryRollNavigation.view.frame), CGRectGetHeight(galleryRollNavigation.view.frame));
        
        [self.view addSubview:galleryRollNavigation.view];
        
        self.firstX = [[sender view] center].x;
    }
    
    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, 0);
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        self.view.center = CGPointMake(translatedPoint.x, self.view.center.y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        //        CGFloat finalX = translatedPoint.x + velocityX;
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        if (self.view.frame.origin.x > -70) {
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.frame = CGRectMake(-CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                [self presentViewController:galleryRollNavigation animated:NO completion:^{
                    
                }];
            }];
        }
    }
}

- (void)logout {
    
    [[MSFolder MR_findFirstByAttribute:@"nameOfFolder" withValue:@"root"] MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [self hideNavBarAndToolBar:YES];
        [self pushViewController:loginViewController animated:YES];
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
