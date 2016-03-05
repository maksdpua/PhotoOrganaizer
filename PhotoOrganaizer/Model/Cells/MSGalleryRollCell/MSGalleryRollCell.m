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
    
    if (model.imageThumbnail.data) {
        self.photo.image = [UIImage imageWithData:model.imageThumbnail.data];
        
        
    } else {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
        
        NSDictionary *paramerts = @{@"path" : model.idPhoto, @"format" : @"jpeg", @"size" : @"w640h480"};
        [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", kContentURL, kGetThumbnail] dictionaryParametrsToJSON:paramerts classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.photo.image = [UIImage imageWithData:responseObject];
                    MSThumbnail *thumbnail = [MSThumbnail MR_createEntity];
                    thumbnail.data = responseObject;
//                    model.imageThumbnail.data = responseObject;
                    model.imageThumbnail = thumbnail;
                    [MBProgressHUD hideAllHUDsForView:self animated:YES];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                });
            });
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"ERROR %@" , error);
        }];
    }
}








@end
