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

static NSString *const kPlaceholder = @"Type folder name for photos stack...";

@interface MSDefaultFolderVC()<UITextViewDelegate, MSRequestManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextView *folderNameTextView;
@property (nonatomic, weak) IBOutlet UIButton *smileButton;
@property IBOutlet NSLayoutConstraint *textViewHeightCosntraint;
@property (nonatomic, strong) MSRequestManager *requestManager;

@end

@implementation MSDefaultFolderVC

- (void)viewDidLoad {
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    
}

#pragma mark - Actions

- (IBAction)createFolderAction:(id)sender {
    [self createFolder];
}

#pragma mark - UITextView delegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {

}

- (void)textViewDidEndEditing:(UITextView *)textView {


}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateTextViewConstraint];
}

- (void)createFolder {
//    NSDictionary *parametrs = @{@"path" : [NSString stringWithFormat:@"/%@",self.folderNameTextView.text]};
    NSDictionary *parametrs = @{@"path" : @"", @"recursive": @NO, @"include_media_info" : @NO, @"include_deleted" :@NO};
    
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parametrs classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
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
