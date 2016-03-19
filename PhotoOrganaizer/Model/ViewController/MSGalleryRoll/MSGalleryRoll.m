//
//  MSGalleryRoll.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/11/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRoll.h"
#import "MSRequestManager.h"
#import "MSAuth.h"
#import "MSFolder.h"
#import "MSGalleryRollCell.h"
#import "MSPhotoImagePickerNavigation.h"
#import "MSFolderPathManager.h"
#import "MSCache.h"
#import <AVFoundation/AVFoundation.h>
#import "MSPhotoLayout.h"

@interface MSGalleryRoll()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation MSGalleryRoll {
    CGFloat cellWidth;
    MSPhotoLayout *layout;
}

- (void)dealloc
{
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.alwaysBounceVertical = YES;
    layout = (MSPhotoLayout *)self.collectionView.collectionViewLayout;
    if (layout) {
        layout.delegate = self;
    }
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    [self createRequestToFolderContent];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.collectionView.delegate = nil;
//    self.collectionView.dataSource = nil;
}

- (void)createRequestToFolderContent {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parametrs = @{@"path" : [[MSFolderPathManager sharedManager] getLastPathInArray], @"recursive": @NO, @"include_media_info" : @YES, @"include_deleted" :@YES};    
    
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parametrs classForFill:[MSFolder class] upload:^(NSProgress *uploadProgress) {
        
    } download:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        MSFolder *folder = [MSFolder MR_findFirstByAttribute:kPath withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
        self.contentArray = [self sortPhotosInArray:folder.photos.allObjects andKey:@"clientModified"];
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        NSLog(@"Error %@", error);
    }];
}

- (IBAction)actionSheet:(id)sender {
    UIAlertController *actSheet = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    UIAlertAction *choosePhoto = [UIAlertAction
                                  actionWithTitle:@"Load new photos..."
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      MSPhotoImagePickerNavigation *photoImagePickerNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSPhotoImagePickerNavigation class])];
                                      [self presentViewController:photoImagePickerNavigation animated:YES completion:nil];
                                 
                                  }];
    UIAlertAction *clearCache = [UIAlertAction
                             actionWithTitle:@"Clear cache"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action) {
                                 [MSThumbnail MR_truncateAll];
                                 [actSheet removeFromParentViewController];
                             }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                                 [actSheet removeFromParentViewController];
                             }];
    UIAlertAction *test = [UIAlertAction
                             actionWithTitle:@"test"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [self test];
                                 [actSheet removeFromParentViewController];
                             }];
    
    [actSheet addAction:choosePhoto];
    [actSheet addAction:clearCache];
    [actSheet addAction:cancel];
    [actSheet addAction:test];
    
    [self presentViewController:actSheet animated:YES completion:nil];
}

- (void)test {

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSGalleryRollCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
    cellWidth = cell.frame.size.width;
    [cell setupWithImage:nil];
    MSPhoto *photo = [self.contentArray objectAtIndex:indexPath.row];
    if (photo.imageThumbnail.data) {
        UIImage *image = [UIImage imageWithData:photo.imageThumbnail.data];
        if (image) {
            [cell setupWithImage:image];
        }
    } else {
        [MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            MSCache *cache = [MSCache new];
            [cache cacheForImageWithKey:photo completeBlock:^(NSData *responseData) {
                if (responseData) {
                    UIImage *image = [UIImage imageWithData:responseData];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MSGalleryRollCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                        
                            if (updateCell) {
                                [updateCell setupWithImage:image];
                            }

                            [MBProgressHUD hideAllHUDsForView:cell.contentView animated:YES];
                            
                            [UIView animateWithDuration:0.5f animations:^{
                                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                            }];
                        });
                    }
                }
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:cell.contentView animated:NO];
            }];
        });
    }
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    MSPhoto *photo = [self.contentArray objectAtIndex:indexPath.row];
//    
//    if (photo.imageThumbnail.data) {
//        UIImage *image = [UIImage imageWithImage:[UIImage imageWithData:photo.imageThumbnail.data] scaledToWidth:self.view.frame.size.width/3];
//        if (image.size.width>=image.size.height) {
//            return CGSizeMake(self.collectionView.contentSize.width/3-1, image.size.height-1);
//        } else {
//            return CGSizeMake(image.size.width-1, image.size.height-1);
//        }
//    }
//    return CGSizeMake(self.collectionView.contentSize.width/3-1, self.collectionView.contentSize.width/3-1);
//    
//}

@end


#pragma mark - LayoutDelegate category

@implementation MSGalleryRoll (LayoutDelegate)

#pragma mark - KGPinterestLayoutAttributesDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width {
    MSPhoto *photo = [self.contentArray objectAtIndex:indexPath.row];
    if (photo.imageThumbnail.data) {
        UIImage *image = [UIImage imageWithData:photo.imageThumbnail.data];
    
        CGRect boundingRect = CGRectMake(0, 0, width, CGFLOAT_MAX);
        CGRect rect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
        return rect.size.height;
    }
    return self.collectionView.frame.size.width/3-1;
    
}





@end
