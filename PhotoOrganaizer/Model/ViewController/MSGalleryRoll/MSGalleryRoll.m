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

@interface MSGalleryRoll()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation MSGalleryRoll

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    [self createRequestToFolderContent];
    
}


- (void)createRequestToFolderContent {
    NSDictionary *parametrs = @{@"path" : [[MSFolderPathManager sharedManager] getLastPathInArray], @"recursive": @NO, @"include_media_info" : @YES, @"include_deleted" :@YES};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parametrs classForFill:[MSFolder class] success:^(NSURLSessionDataTask *task, id responseObject) {
        [self  sortPhotosByDate];
        
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
    }];
}

- (void)sortPhotosByDate {
    MSFolder *mainFolder = [MSFolder MR_findFirstByAttribute:kPath withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clientModified"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.contentArray = [mainFolder.photos.allObjects sortedArrayUsingDescriptors:sortDescriptors];
    
}

- (void)loadPhotosFromData {
    MSFolder *mainFolder = [MSFolder MR_findFirstByAttribute:kPath withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
    self.contentArray = mainFolder.photos.allObjects;
//    if (!self.contentArray) {
//        [self createRequestToFolderContent];
//    }
}


- (IBAction)actionSheet:(id)sender {
    UIAlertController * actSheet=   [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    UIAlertAction* choosePhoto = [UIAlertAction
                                  actionWithTitle:@"Load new photos..."
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      MSPhotoImagePickerNavigation *photoImagePickerNavigation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSPhotoImagePickerNavigation class])];
                                      [self presentViewController:photoImagePickerNavigation animated:YES completion:nil];
                                 
                                  }];
    UIAlertAction* clearCache = [UIAlertAction
                             actionWithTitle:@"Clear cache"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action) {
                                 [MSThumbnail MR_truncateAll];
                                 [actSheet removeFromParentViewController];
                             }];
    UIAlertAction* logout = [UIAlertAction
                             actionWithTitle:@"Logout"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action) {
                                 [MSAuth logout];
                                 [MSFolder MR_truncateAll];
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                                 [actSheet removeFromParentViewController];
                             }];
    
    [actSheet addAction:choosePhoto];
    [actSheet addAction:clearCache];
    [actSheet addAction:logout];
    [actSheet addAction:cancel];
    
    [self presentViewController:actSheet animated:YES completion:nil];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSGalleryRollCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
    [cell setupWithModel:[self.contentArray objectAtIndex:indexPath.row]];
    return cell;
}




@end
