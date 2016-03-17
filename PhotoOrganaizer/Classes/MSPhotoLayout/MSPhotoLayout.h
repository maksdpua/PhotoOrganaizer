//
//  MSPhotoLayout.h
//  PhotoOrganaizer
//
//  Created by Maks on 3/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSPinterestLayoutAttributesDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

@end

//...

@interface MSPinterestLayoutAttributes : UICollectionViewLayoutAttributes <NSCopying>

@property (nonatomic) CGFloat photoHeight;

@end

//...

@interface MSPhotoLayout : UICollectionViewLayout

@property (nonatomic, weak) id <MSPinterestLayoutAttributesDelegate> delegate;

@property (nonatomic) NSInteger numberOfColumns;

@property (nonatomic) CGFloat cellPadding;


- (void)prepareLayout;

- (void)setup;

@end


