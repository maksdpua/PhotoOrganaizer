//
//  MSGalleryRollCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/12/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollCell.h"
#import <AFNetworking/AFNetworking.h>
#import "UIKit+AFNetworking.h"
#import "MSRequestManager.h"

@interface MSGalleryRollCell()<MSRequestManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, strong) MSRequestManager *requestManager;

@end

@implementation MSGalleryRollCell

- (void)setupWithModel:(MSPhoto *)model {
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    NSDictionary *paramerts = @{@"path" : model.path, @"format" : @"jpeg", @"size" : @"w128h128"};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"https://content.dropboxapi.com/2/files/get_thumbnail"] dictionaryParametrsToJSON:paramerts classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSData *data = responseObject;
//            if (!data){
//                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
//                [data writeToFile:path atomically:YES];
//            } else {
                UIImage *img = [UIImage imageWithData:data];
            
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.photo.image = img;
                });
//            }
        });

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR %@" , error);
    }];
}



@end
