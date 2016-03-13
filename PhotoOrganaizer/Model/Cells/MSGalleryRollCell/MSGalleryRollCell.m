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
#import "MSCache.h"

@interface MSGalleryRollCell()

@property (nonatomic, weak) IBOutlet UIImageView *photo;

@end

@implementation MSGalleryRollCell

- (void)setupWithImage:(UIImage *)image {
    self.photo.image = nil;
    self.photo.image = image;
//    if (model.imageThumbnail.data) {
//        self.photo.image = [UIImage imageWithData:model.imageThumbnail.data];
//    } else if (!self.photo.image){
//        [MBProgressHUD showHUDAddedTo:self animated:YES];
//        MSCache *cache = [MSCache new];
//        [cache cacheForImageWithKey:model completeBlock:^(NSData *responseData) {
//            if (!self.photo) {
//                self.photo.image = [UIImage imageWithData:responseData];
//            }
//            [MBProgressHUD hideAllHUDsForView:self animated:YES];
//        } errorBlock:^(NSError *error){
//            NSLog(@"ERROR IN CELL /n %@", error);
//        }];
//    }
}

@end
