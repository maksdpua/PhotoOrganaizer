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
#import "MSGalleryRollLoadCell.h"
#import "MSPhotoImagePickerNavigation.h"
#import "MSFolderPathManager.h"
#import "MSCache.h"
#import <AVFoundation/AVFoundation.h>
#import "MSPhotoLayout.h"
#import "MSGalleryRollDataSource.h"
#import "MSManagerDownloads.h"
#import "MSSavingProcessView.h"

@interface MSGalleryRoll()<MSRequestManagerDelegate, MSGalleryRollDataSourceDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property NSOperationQueue *imageLoadingOperationQueue;
@property (nonatomic, strong) NSMutableArray *uploadingThumbnails;
@property (nonatomic, strong) NSMutableDictionary *thumbnailsToUpload;
@property (nonatomic, strong) MSGalleryRollDataSource *dataSource;
@property (nonatomic, strong) MSSavingProcessView *processView;

@end

@implementation MSGalleryRoll

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[MSGalleryRollDataSource alloc]initWithDelegate:self];
    self.uploadingThumbnails = [NSMutableArray new];
    self.imageLoadingOperationQueue = [NSOperationQueue new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotosFromPhotoCollection:) name:kPhotosWasSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView) name:MANAGER_DOWNLOADS_DID_FINISH_NOTIFICATION object:nil];

    self.collectionView.alwaysBounceVertical = YES;
    MSPhotoLayout *layout = (MSPhotoLayout *)self.collectionView.collectionViewLayout;
    if (layout) {
        layout.delegate = self;
    }
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    [self createRequestToFolderContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.thumbnailsToUpload = [NSMutableDictionary new];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //Cancel all operations with load images
    [self.imageLoadingOperationQueue cancelAllOperations];
}

- (void)dealloc {
    [self.uploadingThumbnails removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Requests and upload data

//request to server

- (void)createRequestToFolderContent {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parametrs = @{@"path" : [[MSFolderPathManager sharedManager] getLastPathInArray], @"recursive": @NO, @"include_media_info" : @YES, @"include_deleted" :@YES};    
    
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parametrs classForFill:[MSFolder class] upload:^(NSProgress *uploadProgress) {
        
    } download:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        MSFolder *folder = [MSFolder MR_findFirstByAttribute:kPath withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
//        NSArray *dataArray = [self sortPhotosInArray:folder.photos.allObjects andKey:@"clientModified"];
//        self.contentArray = [NSMutableArray new];
//        [self.contentArray addObjectsFromArray:dataArray];
//        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        NSLog(@"Error %@", error);
    }];
}

#pragma mark - Notifications methods

- (void)uploadPhotosFromPhotoCollection:(NSNotification *)notification {
    [self.collectionView reloadData];

}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
}

#pragma mark - Actions

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
    
    [actSheet addAction:choosePhoto];
    [actSheet addAction:clearCache];
    [actSheet addAction:cancel];
    
    [self presentViewController:actSheet animated:YES completion:nil];
}

#pragma mark - UICollectionView datasource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self.collectionView.collectionViewLayout invalidateLayout];
    if ([[MSManagerDownloads sharedManager] modelsCount] > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([[MSManagerDownloads sharedManager] modelsCount] > 0) {
        if (section == 0) {
            return [[MSManagerDownloads sharedManager] modelsCount];
        } else {
            return [self.dataSource countOfModels];
        }
    } else {
        return [self.dataSource countOfModels];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSGalleryRollCell *cell = [MSGalleryRollCell new];
    MSGalleryRollLoadCell *loadCell = [MSGalleryRollLoadCell new];
    if ([[MSManagerDownloads sharedManager] modelsCount] > 0) {
        if (indexPath.section == 0) {
            loadCell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollLoadCell forIndexPath:indexPath];
            [loadCell setupWithModel:[[MSManagerDownloads sharedManager] uploadModelAtIndex:indexPath.row]];
            return loadCell;
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
            [cell setupWithImage:nil];
            
            id obj = [self.dataSource modelAtIndex:indexPath.row];
            if ([[obj class]isSubclassOfClass:[MSPhoto class]]) {
                [self loadImageInCell:cell indexPath:indexPath andPhotoObject:obj];
            }
            return cell;
        }
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
        [cell setupWithImage:nil];
        
        id obj = [self.dataSource modelAtIndex:indexPath.row];
        if ([[obj class]isSubclassOfClass:[MSPhoto class]]) {
            [self loadImageInCell:cell indexPath:indexPath andPhotoObject:obj];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[MSManagerDownloads sharedManager]modelsCount] > 0 && indexPath.section == 0) {
        MSUploadInfo *uploadInfo = [[MSManagerDownloads sharedManager]uploadModelAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(updateProgress:) name:uploadInfo.path object:nil];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[MSManagerDownloads sharedManager] modelsCount] && indexPath.section == 0) {
        MSUploadInfo *uploadInfo = [[MSManagerDownloads sharedManager]uploadModelAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] removeObserver:cell name:uploadInfo.path object:nil];
    } else {
        [self forItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *actSheet = [UIAlertController
                                   alertControllerWithTitle:nil
                                   message:nil
                                   preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *savePhoto = [UIAlertAction
                                  actionWithTitle:@"Save photo..."
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      MSPhoto *model = [self.dataSource modelAtIndex:indexPath.row];
                                      self.processView = [[MSSavingProcessView alloc]initOnView:self.navigationController.view path:model.path];
                                      
                                  }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                                 [actSheet removeFromParentViewController];
                             }];
    
    [actSheet addAction:savePhoto];
    [actSheet addAction:cancel];
    
    [self presentViewController:actSheet animated:YES completion:nil];
}

- (void)forItemAtIndexPath:(NSIndexPath *)indexPath {
    
        MSPhoto *obj = [self.dataSource modelAtIndex:indexPath.row];
        NSBlockOperation *ongoingDownloadOperation = [self.thumbnailsToUpload objectForKey:obj.path];
        if (ongoingDownloadOperation) {
            //Cancel operation and remove from dictionary
            [ongoingDownloadOperation cancel];
            [self.thumbnailsToUpload removeObjectForKey:obj.path];
        }
}

#pragma mark - Work with image load methods

//download image thumbnail in cell

- (void)loadImageInCell:(MSGalleryRollCell *)cell indexPath:(NSIndexPath *)indexPath andPhotoObject:(id)obj {
    MSPhoto *photo = obj;
    if (photo.imageThumbnail.data) {
        [MBProgressHUD hideAllHUDsForView:cell.contentView animated:NO];
        UIImage *image = [UIImage imageWithData:photo.imageThumbnail.data];
        if (image) {
            [cell setupWithImage:image];
        }
    }   else {
        [MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
        
        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakLoadImageIntoCellOp = loadImageIntoCellOp;
        [loadImageIntoCellOp addExecutionBlock:^{
            
            MSCache *cache = [MSCache new];
            [cache cacheForImageWithKey:photo completeBlock:^(NSData *responseData) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!weakLoadImageIntoCellOp.isCancelled) {
                        if (responseData) {
                            UIImage *image = [UIImage imageWithData:responseData];
                            if (image) {
                                [MBProgressHUD hideAllHUDsForView:cell.contentView animated:YES];
                                MSGalleryRollCell *updateCell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
                                if (updateCell) {
                                    [updateCell setupWithImage:image];
                                }
                                [UIView animateWithDuration:0.5f animations:^{
                                    [self.collectionViewLayout invalidateLayout];
                                }];
                                if (photo.path) {
                                    [self.thumbnailsToUpload removeObjectForKey:photo.path];
                                }
                                
                            }
                        }
                    }
                }];
            } errorBlock:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:cell.contentView animated:NO];
            }];
        }];
        if (photo.path) {
            [self.thumbnailsToUpload setObject:loadImageIntoCellOp forKey:photo.path];
        }
        if (loadImageIntoCellOp) {
            [self.imageLoadingOperationQueue addOperation:loadImageIntoCellOp];
        }
        [cell setupWithImage:nil];
    }
}

#pragma mark - MSGalleryRollDataSourceDelegate methods

- (void)contentWasChangedAtIndex:(NSUInteger)sectionIndex {
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
}

- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        [self.collectionView reloadData];
    } else if (type == NSFetchedResultsChangeUpdate) {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

@end


#pragma mark - LayoutDelegate category

@implementation MSGalleryRoll (LayoutDelegate)

#pragma mark - KGPinterestLayoutAttributesDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width {
    CGFloat resultHeight;
    
    if ([[MSManagerDownloads sharedManager] modelsCount] > 0 && [self.collectionView numberOfSections]>1 && indexPath.section == 0) {
        resultHeight = self.collectionView.frame.size.width/3-1;
    } else if ([[MSManagerDownloads sharedManager] modelsCount] > 0 && [self.collectionView numberOfSections] == 1){
        resultHeight = self.collectionView.frame.size.width/3-1;
    } else {
        resultHeight = [self calculateHeightForItemAtIndexPath:indexPath andWidth:width];
    }
    return resultHeight;
    
}

- (CGFloat)calculateHeightForItemAtIndexPath:(NSIndexPath *)indexPath andWidth:(CGFloat)width {
    MSPhoto *photo = [self.dataSource modelAtIndex:indexPath.row];
    if (photo.imageThumbnail.data) {
        UIImage *image = [UIImage imageWithData:photo.imageThumbnail.data];
        return [self calculateHeightFromImage:image andWidth:width];
    } else {
        return  self.collectionView.frame.size.width/3-1;
    }
}

- (CGFloat)calculateHeightFromImage:(UIImage *)image andWidth:(CGFloat)width {
    CGRect boundingRect = CGRectMake(0, 0, width, CGFLOAT_MAX);
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
    
    return rect.size.height;
}

@end
