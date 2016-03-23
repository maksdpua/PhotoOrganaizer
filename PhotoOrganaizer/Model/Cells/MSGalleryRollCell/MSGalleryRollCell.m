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



@end

@implementation MSGalleryRollCell

- (void)setupWithImage:(UIImage *)image {
    self.photo.image = nil;
    self.photo.image = image;
}

@end
