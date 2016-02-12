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

@interface MSGalleryRollCell()

@property (nonatomic, weak) IBOutlet UIImageView *photo;

@end

@implementation MSGalleryRollCell

- (void)setupWithModel:(MSPhoto *)model {
    [self.photo setImageWithURL:[NSURL URLWithString:model.path]];
}



@end
