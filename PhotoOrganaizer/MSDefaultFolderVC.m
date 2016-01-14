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

static NSString *const kPlaceholder = @"Type folder name for photos stack...";

@interface MSDefaultFolderVC()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *folderNameTextView;
@property (nonatomic, weak) IBOutlet UIButton *smileButton;
@property IBOutlet NSLayoutConstraint *textViewHeightCosntraint;

@end

@implementation MSDefaultFolderVC

- (void)viewDidLoad {
    NSDictionary *parametrs = @{@"path" : @"",
                                @"recursive": @NO,
                                @"include_media_info": @NO,
                                @"include_deleted": @NO};
    NSString *jsonParametrs =[NSDictionary convertDictionaryToJSONstringWith:parametrs];
    NSString *string = [NSString stringWithFormat: @"{\"path\": \"\",\"recursive\": false,\"include_media_info\": false,\"include_deleted\": false}"];
    

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametrs
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    AFHTTPSessionManager *managerRequest = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [managerRequest.requestSerializer requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] parameters:nil error:&error];
    NSData *postData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setValue: [NSString stringWithFormat:@"Bearer %@" ,[MSAuth token]] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    
    __block NSURLSessionDataTask *task = [managerRequest dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            NSLog(@"%@", responseObject);
        }
    }];
    
    [task resume];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

}

- (void)textViewDidEndEditing:(UITextView *)textView
{

//    [textView resignFirstResponder];
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
