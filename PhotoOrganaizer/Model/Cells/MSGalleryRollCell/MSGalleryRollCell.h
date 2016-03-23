//
//  MSGalleryRollCell.h
//  PhotoOrganaizer
//
//  Created by Maks on 2/12/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPhoto.h"

@interface MSGalleryRollCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *photo;

- (void)setupWithImage:(UIImage *)image;

@end
