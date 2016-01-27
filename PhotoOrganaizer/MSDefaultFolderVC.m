//
//  MSDefaultFolderVC.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/10/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSDefaultFolderVC.h"
#import "MSAPIRequestManager.h"
#import "MSAuth.h"
#import <AFNetworking.h>
#import "MSRequestManager.h"
#import "MSFolder.h"
#import "MSAPIMethodsManager.h"
#import "MSPhoto.h"
#import "MSFolderViewer.h"

@interface MSDefaultFolderVC()<UITextViewDelegate, MSRequestManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextView *folderNameTextView;
@property (nonatomic, weak) IBOutlet UIButton *smileButton;
@property IBOutlet NSLayoutConstraint *textViewHeightCosntraint;
@property (nonatomic, strong) MSRequestManager *requestManager;

@end

@implementation MSDefaultFolderVC {
    MSAPIMethodsManager *_apiMethodManager;
}

- (void)viewDidLoad {
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    _apiMethodManager = [[MSAPIMethodsManager alloc]init];
    
    NSArray *array = [MSPhoto MR_findAll];
    NSArray *arra2 = [MSFolder MR_findAll];
    for (MSPhoto *ee in array) {
        NSLog(@"PHOTOS -- %@", ee.namePhoto);
    }
    for (MSFolder *fold in arra2) {
        NSLog(@"FOLDERS -- %@", fold.nameOfFolder);
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Actions

- (IBAction)createFolderAction:(id)sender {
//    [NSString stringWithFormat:@"/%@",self.folderNameTextView.text]
    [_apiMethodManager getFolderContentWithPath:@""];
    
}

- (IBAction)chooseDefaultFolder:(id)sender {
    MSFolderViewer *folderViewerVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
    [self.navigationController pushViewController:folderViewerVC animated:YES];
}

#pragma mark - UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {

}

- (void)textViewDidEndEditing:(UITextView *)textView {


}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateTextViewConstraint];
}

- (void)updateTextViewConstraint {
    [self.view setNeedsDisplay];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat fixedWidth = self.folderNameTextView.frame.size.width;
        CGSize newSize = [self.folderNameTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = self.folderNameTextView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        self.textViewHeightCosntraint.constant = newFrame.size.height;
        [self.view layoutIfNeeded];
    }];
}


@end
