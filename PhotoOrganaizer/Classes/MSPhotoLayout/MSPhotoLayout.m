//
//  MSPhotoLayout.m
//  PhotoOrganaizer
//
//  Created by Maks on 3/15/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSPhotoLayout.h"

#pragma mark - PinterestLayoutAttributes

@implementation MSPinterestLayoutAttributes

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    MSPinterestLayoutAttributes *copy = [super copyWithZone:zone];
    copy.photoHeight = self.photoHeight;
    return copy;
}

- (BOOL)isEqual:(id)object
{
    MSPinterestLayoutAttributes *attributtes = object;
    if (attributtes.photoHeight == self.photoHeight)
    {
        return [super isEqual:object];
    }
    return NO;
}

#pragma mark - Setup

- (void)setup
{
    self.photoHeight = 0.f;
}

@end

#pragma mark - PinterestLayout

@interface MSPhotoLayout ()

@property (nonatomic) NSMutableArray <MSPinterestLayoutAttributes *> *cache;
@property (nonatomic) NSMutableArray <MSPinterestLayoutAttributes *> *secondeCache;
@property (nonatomic) NSMutableDictionary *dicCache;
@property (nonatomic) CGFloat contentHeight;
@property (nonatomic) CGFloat contentWidth;

@end

@implementation MSPhotoLayout

#pragma mark - Init

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    self.cache = [NSMutableArray new];
    self.secondeCache = [NSMutableArray new];
    self.numberOfColumns = 3;
    self.cellPadding = 1.f;
    self.contentHeight = 0.f;
    
}

#pragma mark - Getters

- (CGFloat)contentWidth
{
//    UIEdgeInsets insets = self.collectionView.contentInset;
//    return CGRectGetHeight(self.collectionView.bounds) - (insets.left + insets.right);
    return self.collectionView.frame.size.width;
}

+ (Class)layoutAttributesClass
{
    return [MSPinterestLayoutAttributes class];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:self.cache];
    [allAttributes addObjectsFromArray:self.secondeCache];
    NSMutableArray <UICollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray new];
    
    [allAttributes enumerateObjectsUsingBlock:^(MSPinterestLayoutAttributes * _Nonnull attributes, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.cache objectAtIndex:indexPath.row];
    } else {
        return [self.secondeCache objectAtIndex:indexPath.row];
    }
}






#pragma mark - Interface

- (void)prepareLayout {
//    if (!self.cache.count)
//    {
        CGFloat columnWidth = self.contentWidth / self.numberOfColumns;
        
        NSMutableArray <NSNumber *> *xOffset = [NSMutableArray new];
        
        for (int i = 0; i < self.numberOfColumns; i++)
        {
            [xOffset addObject:@(i * columnWidth)];
        }
        NSInteger column = 0;
        
        NSMutableArray <NSNumber *> *yOffset = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
        for (int i = 0; i < self.numberOfColumns; i++) {
            [yOffset addObject:[NSNumber numberWithFloat:0.f]];
        }
        self.cache = [NSMutableArray new];
        self.contentHeight = 0;
    
        for (int i = 0; i < [self.collectionView numberOfSections]; i++)
        {
            for (int j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                
                CGFloat width = columnWidth - self.cellPadding * 2;
                CGFloat photoHeight = [self.delegate collectionView:self.collectionView heightForPhotoAtIndexPath:indexPath withWidth:width];
                CGFloat height = self.cellPadding + photoHeight + self.cellPadding;
                
                CGRect frame = CGRectMake(xOffset[column].floatValue, yOffset[column].floatValue, columnWidth, height);
                CGRect insetFrame = CGRectInset(frame, self.cellPadding, self.cellPadding);
                
                MSPinterestLayoutAttributes *attributes = [MSPinterestLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.photoHeight = photoHeight;
                attributes.frame = insetFrame;
                if (i == 0) {
                    if (self.cache.count > indexPath.row) {
                        [self.cache replaceObjectAtIndex:indexPath.row withObject:attributes];
                    } else {
                        [self.cache addObject:attributes];
                    }
                } else if (i == 1) {
                    if (self.secondeCache.count > indexPath.row) {
                        [self.secondeCache replaceObjectAtIndex:indexPath.row withObject:attributes];
                    } else {
                        [self.secondeCache addObject:attributes];
                    }
                }
                
                
//                if (self.cache.count > indexPath.row) {
//                    [self.cache replaceObjectAtIndex:indexPath.row withObject:attributes];
//                } else {
//                    [self.cache addObject:attributes];
//                }
                
                self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(frame));
                yOffset[column] = @(yOffset[column].floatValue + height);
                
                column = column >= (self.numberOfColumns - 1) ? 0 : ++column;
            }
            
        }
//    }
}


@end
