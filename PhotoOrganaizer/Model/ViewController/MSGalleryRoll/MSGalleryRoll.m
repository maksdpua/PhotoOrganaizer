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
#import "MSGalleryRollDataSource.h"

@interface MSGalleryRoll()<MSRequestManagerDelegate, MSGalleryRollDataSourceDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property NSOperationQueue *imageLoadingOperationQueue;
@property (nonatomic, strong) NSMutableArray *photosNameToUpload;
@property (nonatomic, strong) NSMutableDictionary *thumbnailsToUpload;
@property (nonatomic, strong) MSGalleryRollDataSource *dataSource;

@end

@implementation MSGalleryRoll

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[MSGalleryRollDataSource alloc]initWithDelegate:self];
    self.photosNameToUpload = [NSMutableArray new];
    self.imageLoadingOperationQueue = [NSOperationQueue new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotosFromPhotoCollection:) name:kPhotosWasSelected object:nil];
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
    [self.photosNameToUpload removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)contentWasChanged {
    [self.collectionView reloadData];
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

//Notification with new imagedata to upload

- (void)uploadPhotosFromPhotoCollection:(NSNotification *)notification {
    NSMutableArray *photos = notification.object;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)];
    [self.contentArray insertObjects:photos atIndexes:set];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return self.contentArray.count;
    return [self.dataSource countOfModels];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSGalleryRollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
    [cell setupWithImage:nil];
    
//    id obj = [self.contentArray objectAtIndex:indexPath.row];
    id obj = [self.dataSource modelAtIndex:indexPath.row];
    if ([[obj class]isSubclassOfClass:[NSDictionary class]]) {
        [self uploadImageDataToServerWithCell:cell indexPath:indexPath andPhotoObject:obj];
    } else if ([[obj class]isSubclassOfClass:[MSPhoto class]]) {
        [self loadImageInBackgroundWithCell:cell indexPath:indexPath andPhotoObject:obj];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    MSPhoto *obj = [self.contentArray objectAtIndex:indexPath.row];
    MSPhoto *obj = [self.dataSource modelAtIndex:indexPath.row];
    if (self.thumbnailsToUpload.count > 0) {
        NSBlockOperation *ongoingDownloadOperation = [self.thumbnailsToUpload objectForKey:obj.path];
        if (ongoingDownloadOperation) {
            //Cancel operation and remove from dictionary
            [ongoingDownloadOperation cancel];
            [self.thumbnailsToUpload removeObjectForKey:obj.path];
        }
    }
    
}

#pragma mark - Work with image load methods

//Upload images to server in cell

- (void)uploadImageDataToServerWithCell:(MSGalleryRollCell *)cell indexPath:(NSIndexPath *)indexPath andPhotoObject:(id)obj {
    NSDictionary *dataDic = obj;
    if (![self.photosNameToUpload containsObject:[dataDic valueForKey:@"imageName"]]) {
        [self.photosNameToUpload addObject:[dataDic valueForKey:@"imageName"]];
        [MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
        NSBlockOperation *uploadImage = [NSBlockOperation new];
        [uploadImage addExecutionBlock:^{
            NSDictionary *param = @{@"path" : [NSString stringWithFormat:@"%@/%@", [[MSFolderPathManager sharedManager]getLastPathInArray],[dataDic valueForKey:@"imageName"]], @"mode" : @"add", @"autorename" : @YES, @"mute" : @NO};
            [self.requestManager createRequestWithPOSTmethodWithFileUpload:[dataDic valueForKey:@"imageData"] stringURL:[NSString stringWithFormat:@"%@files/upload", kContentURL] dictionaryParametrsToJSON:param classForFill:nil upload:^(NSProgress *uploadProgress) {
                //                    NSLog(@"Upload %f", uploadProgress.fractionCompleted);
            } download:^(NSProgress *downloadProgress) {
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [cell setupWithImage:[UIImage imageWithData:[dataDic valueForKey:@"imageData"]]];
                    [MBProgressHUD hideAllHUDsForView:cell.contentView animated:YES];
                    [self.collectionViewLayout invalidateLayout];
                }];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@", error);
            }];
        }];
        [uploadImage start];
    }
}

//download image thumbnail in cell

- (void)loadImageInBackgroundWithCell:(MSGalleryRollCell *)cell indexPath:(NSIndexPath *)indexPath andPhotoObject:(id)obj {
    MSPhoto *photo = obj;
    if (photo.imageThumbnail.data) {
        UIImage *image = [UIImage imageWithData:photo.imageThumbnail.data];
        if (image) {
            [cell setupWithImage:image];
        }
    } /*else {
        [MBProgressHUD showHUDAddedTo:cell.contentView animated:YES];
        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
        [loadImageIntoCellOp addExecutionBlock:^{
            
            MSCache *cache = [MSCache new];
            [cache cacheForImageWithKey:photo completeBlock:^(NSData *responseData) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (!weakOp.isCancelled) {
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
        //Add the operation to the designated background queue
        if (loadImageIntoCellOp) {
            [self.imageLoadingOperationQueue addOperation:loadImageIntoCellOp];
        }
        [cell setupWithImage:nil];
    }*/
}

@end


#pragma mark - LayoutDelegate category

@implementation MSGalleryRoll (LayoutDelegate)

#pragma mark - KGPinterestLayoutAttributesDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width {
    CGFloat resultHeight;
//    id obj = [self.contentArray objectAtIndex:indexPath.row];
    id obj = [self.dataSource modelAtIndex:indexPath.row];
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

@end
