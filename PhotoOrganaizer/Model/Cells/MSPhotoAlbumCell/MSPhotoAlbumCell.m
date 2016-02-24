//
//  MSPhotoAlbumCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/24/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSPhotoAlbumCell.h"

@interface MSPhotoAlbumCell()

@property (nonatomic, weak) IBOutlet UIImageView *titleAlbumPhoto;
@property (nonatomic, weak) IBOutlet UILabel *titleAlbumLabel;
@property CGRect previousPreheatRect;

@end

@implementation MSPhotoAlbumCell

static CGSize AssetGridThumbnailSize;

- (void)setupWithModel:(PHCollection *)model {
    PHAsset *asset = nil;
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc]init];
    if ([model isKindOfClass:[PHAssetCollection class]]) {
        PHAssetCollection *assetCollection = (PHAssetCollection *)model;
        asset = [[PHAsset fetchAssetsInAssetCollection:assetCollection options:nil] lastObject];
        self.titleAlbumLabel.text = model.localizedTitle;
    } else {
        asset = (PHAsset *)model;
        self.titleAlbumLabel.text = @"All Photos";
    }
    [imageManager requestImageForAsset:asset
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             if (result) {
                                 self.titleAlbumPhoto.image = result;
                             } else {
                                 self.titleAlbumPhoto.image = [UIImage folderPic];
                             }
                             

                         }];
}

- (void)awakeFromNib {
    AssetGridThumbnailSize = [self sizeForAssetGridThumbnailSize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rowHeight" object:[NSNumber numberWithFloat:AssetGridThumbnailSize.height]];
}

- (CGSize)sizeForAssetGridThumbnailSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = self.contentView.frame.size;
    return CGSizeMake(cellSize.width * scale, cellSize.height * scale);;
}



@end
