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

@interface MSFolderViewNavigation ()<UIGestureRecognizerDelegate>

@property (nonatomic) CGFloat firstX;

@end

@implementation MSFolderViewNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panRecognizer];

}

- (void)didSwipeLeft:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:self.view];
    MSGalleryRollNavigation *galleryRollNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRollNavigation class])];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        
        galleryRollNavigation.view.frame = CGRectMake(CGRectGetWidth(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(galleryRollNavigation.view.frame), CGRectGetHeight(galleryRollNavigation.view.frame));
        
        [self.view addSubview:galleryRollNavigation.view];
        
        self.firstX = [[sender view] center].x;
    }
    
    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, 0);
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        self.view.center = CGPointMake(translatedPoint.x, self.view.center.y);
        NSLog(@"location %@", NSStringFromCGPoint(self.view.frame.origin));
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        //        CGFloat finalX = translatedPoint.x + velocityX;
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        if (self.view.frame.origin.x > -70) {
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:nil];
        } else {
            [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.view.frame = CGRectMake(-CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                [self presentViewController:galleryRollNavigation animated:NO completion:nil];
            }];
        }
        
    }
    
    
    
    
    
    
    
    
    
//    CGPoint touchPoint = [sender locationInView:self.view];
//    NSLog(@"TOUCH %@", NSStringFromCGPoint(touchPoint));
//    MSGalleryRollNavigation *galleryRollNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSGalleryRollNavigation class])];
//    
//    galleryRollNavigation.view.frame = CGRectMake (self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    
//    
//    [UIView animateWithDuration:0.7 animations:^{
//        [self.view addSubview:galleryRollNavigation.view];
//        self.view.frame = CGRectMake (self.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//        
//            } completion:^(BOOL finished) {
//        [galleryRollNavigation.view removeFromSuperview];
//
//        [self presentViewController:galleryRollNavigation animated:NO completion:^{
//            
//        }];
//    }];

    
}



@end
