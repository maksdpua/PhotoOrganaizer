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
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation MSGalleryRoll

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotosFromPhotoCollection:) name:kPhotosWasSelected object:nil];
    self.collectionView.alwaysBounceVertical = YES;
    MSPhotoLayout *layout = (MSPhotoLayout *)self.collectionView.collectionViewLayout;
    if (layout) {
        layout.delegate = self;
    }
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    [self createRequestToFolderContent];
}





- (void)createRequestToFolderContent {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parametrs = @{@"path" : [[MSFolderPathManager sharedManager] getLastPathInArray], @"recursive": @NO, @"include_media_info" : @YES, @"include_deleted" :@YES};    
    
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parametrs classForFill:[MSFolder class] upload:^(NSProgress *uploadProgress) {
        
    } download:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        MSFolder *folder = [MSFolder MR_findFirstByAttribute:kPath withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
        NSArray *dataArray = [self sortPhotosInArray:folder.photos.allObjects andKey:@"clientModified"];
        self.contentArray = [NSMutableArray new];
        [self.contentArray addObjectsFromArray:dataArray];
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        NSLog(@"Error %@", error);
    }];
}

- (void)uploadPhotosFromPhotoCollection:(NSNotification *)notification {
    NSMutableArray *photos = notification.object;
    NSUInteger resultsSize = self.contentArray.count;
    [self.contentArray addObjectsFromArray:photos];
    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
    [self.collectionView performBatchUpdates:^{
        
        for (NSUInteger i = resultsSize; i < resultsSize + photos.count; i++) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i
                                                              inSection:0]];
        }
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
        
    } completion:nil];
    
    [self.collectionView performBatchUpdates:^{
        for (NSUInteger i = 0; i<arrayWithIndexPaths.count; i++) {
            
             [self.collectionView moveItemAtIndexPath:arrayWithIndexPaths[i] toIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        
    } completion:nil];
    
    
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
    MSGalleryRollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
    
    [cell setupWithImage:nil];
    
    id obj = [self.contentArray objectAtIndex:indexPath.row];
    
    
    
    
    
    
    
    
    
    if ([[obj class]isSubclassOfClass:[NSDictionary class]]) {
        [MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
        NSDictionary *dataDic = [self.contentArray objectAtIndex:indexPath.row];
        [cell setupWithImage:[UIImage imageWithData:[dataDic valueForKey:@"imageData"]]];
        NSBlockOperation *uploadImage = [[NSBlockOperation alloc] init];
        if (!uploadImage.isExecuting) {
            [uploadImage addExecutionBlock:^{
                NSDictionary *param = @{@"path" : [NSString stringWithFormat:@"%@/%@", [[MSFolderPathManager sharedManager]getLastPathInArray],[dataDic valueForKey:@"imageName"]], @"mode" : @"add", @"autorename" : @YES, @"mute" : @NO};
                [self.requestManager createRequestWithPOSTmethodWithFileUpload:[dataDic valueForKey:@"imageData"] stringURL:[NSString stringWithFormat:@"%@files/upload", kContentURL] dictionaryParametrsToJSON:param classForFill:nil upload:^(NSProgress *uploadProgress) {
//                    NSLog(@"Upload %f", uploadProgress.fractionCompleted);
                } download:^(NSProgress *downloadProgress) {
                    
                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSLog(@"%@", responseObject);
                        [MBProgressHUD hideAllHUDsForView:cell.contentView animated:YES];
                    }];
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@", error);
                }];
            }];
            [uploadImage start];
        }
        
    } else if ([[obj class]isSubclassOfClass:[MSPhoto class]]) {
        MSPhoto *photo = obj;
        if (photo.imageThumbnail.data) {
            [MBProgressHUD hideAllHUDsForView:cell.contentView animated:NO];
            UIImage *image = [UIImage imageWithData:photo.imageThumbnail.data];
            if (image) {
                [cell setupWithImage:image];
            }
        } else {
            NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
            if (!loadImageIntoCellOp.isExecuting) {
                [loadImageIntoCellOp addExecutionBlock:^{
                    [MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
                    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    MSCache *cache = [MSCache new];
                    [cache cacheForImageWithKey:photo completeBlock:^(NSData *responseData) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (responseData) {
                                UIImage *image = [UIImage imageWithData:responseData];
                                if (image) {
                                    //                            dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [MBProgressHUD hideAllHUDsForView:cell.contentView animated:YES];
                                    MSGalleryRollCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                                    
//                                    [MBProgressHUD hideAllHUDsForView:updateCell.contentView animated:NO];
                                    if (updateCell) {
//                                        [updateCell setupWithImage:nil];
                                        [updateCell setupWithImage:image];
                                    } else {
//                                        [updateCell setupWithImage:nil];
                                    }
                                    [UIView animateWithDuration:0.5f animations:^{
                                        [self.collectionViewLayout invalidateLayout];
                                    }];
                                    //                            });
                                }
                            }
                        }];
                        
                    } errorBlock:^(NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:cell.contentView animated:NO];
                    }];
                }];
                [loadImageIntoCellOp start];
            }
            
//            });
        }
    }
    
    return cell;
}



@end


#pragma mark - LayoutDelegate category

@implementation MSGalleryRoll (LayoutDelegate)

#pragma mark - KGPinterestLayoutAttributesDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width {
    CGFloat resultHeight;
    id obj = [self.contentArray objectAtIndex:indexPath.row];
    UIImage *image = [UIImage new];
    if ([[obj class] isSubclassOfClass:[MSPhoto class]]) {
        MSPhoto *photo = obj;
        if (photo.imageThumbnail.data) {
            image = [UIImage imageWithData:photo.imageThumbnail.data];
            resultHeight =  [self calculateHeightFromImage:image andWidth:width];
        } else {
            resultHeight = self.collectionView.frame.size.width/3-1;
        }
    } else if ([[obj class] isSubclassOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = obj;
        image = [UIImage imageWithData:[dataDic valueForKey:@"imageData"]];
        resultHeight =  [self calculateHeightFromImage:image andWidth:width];
    }
    
    return resultHeight;
    
}

- (CGFloat)calculateHeightFromImage:(UIImage *)image andWidth:(CGFloat)width {
    CGRect boundingRect = CGRectMake(0, 0, width, CGFLOAT_MAX);
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
    
    return rect.size.height;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
