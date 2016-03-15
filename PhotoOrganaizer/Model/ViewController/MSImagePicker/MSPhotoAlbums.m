//
//  MSImagePicker.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/24/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSPhotoAlbums.h"
#import "MSPhotoAlbumCell.h"
#import "MSPhotoCollection.h"

@import Photos;

@interface MSPhotoAlbums()<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;

@end

@implementation MSPhotoAlbums


- (void)awakeFromNib {
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[smartAlbums, topLevelUserCollections];
    self.sectionLocalizedTitles = @[NSLocalizedString(@"Smart Albums", @""), NSLocalizedString(@"Albums", @"")];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            [self.tableView reloadData];
        }
        
    });
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    PHFetchResult *fetchResult = self.sectionFetchResults[section];
    numberOfRows = fetchResult.count;
    
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSPhotoAlbumCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSPhotoAlbumCell class]) forIndexPath:indexPath];
    
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    [cell setupWithModel:fetchResult[indexPath.row]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionLocalizedTitles[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
    // Configure the AAPLAssetGridViewController with the asset collection.
    PHCollection *collection = fetchResult[indexPath.row];
    PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    MSPhotoCollection *collectionGrid = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSPhotoCollection class])];
    
    collectionGrid.assetsFetchResults = assetsFetchResult;
    collectionGrid.assetCollection = assetCollection;
    collectionGrid.title = assetCollection.localizedTitle;
    
    [self.navigationController pushViewController:collectionGrid animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}









@end
