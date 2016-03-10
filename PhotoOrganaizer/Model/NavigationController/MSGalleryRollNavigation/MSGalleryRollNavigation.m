//
//  MSGalleryRollNavigation.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollNavigation.h"
#import "MSFolderViewNavigation.h"
#import "MSGalleryRoll.h"

@interface MSGalleryRollNavigation()

@property (nonatomic) CGFloat firstX;

@end

@implementation MSGalleryRollNavigation {
    MSFolderViewNavigation *folderViewNavigation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panRecognizer];
    folderViewNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewNavigation class])];
    
}

- (void)didSwipeLeft:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:self.view];
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        
        folderViewNavigation.view.frame = CGRectMake(CGRectGetMinX(self.view.frame) - CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(folderViewNavigation.view.frame), CGRectGetHeight(folderViewNavigation.view.frame));
        
        [self.view addSubview:folderViewNavigation.view];
        
        self.firstX = [[sender view] center].x;
    }
    
    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, 0);
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.view.center = CGPointMake(translatedPoint.x, self.view.center.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        //        CGFloat finalX = translatedPoint.x + velocityX;
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        if (self.view.frame.origin.x < 70) {
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:nil];
        } else {
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.frame = CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }];
        }
        
        
    }
}






@end
