//
//  MSPhotoAlbumCell.h
//  PhotoOrganaizer
//
//  Created by Maks on 2/24/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

@interface MSPhotoAlbumCell : UITableViewCell

- (void)setupWithModel:(PHCollection *)model;

- (CGSize)sizeForAssetGridThumbnailSize;

@end
