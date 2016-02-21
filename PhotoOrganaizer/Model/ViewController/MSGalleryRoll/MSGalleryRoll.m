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

@interface MSGalleryRoll()<MSRequestManagerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation MSGalleryRoll

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createRequestToFolderContent) name:@"swipeDidBegin" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self createRequestToFolderContent];
}

- (void)createRequestToFolderContent {
    NSDictionary *parametrs = @{@"path" : [MSAuth defaulFolderPath], @"recursive": @NO, @"include_media_info" : @YES, @"include_deleted" :@YES};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parametrs classForFill:[MSFolder class] success:^(NSURLSessionDataTask *task, id responseObject) {
        MSFolder *mainFolder = [MSFolder MR_findFirstByAttribute:kPath withValue:[MSAuth defaulFolderPath]];
        self.contentArray = mainFolder.photos.allObjects;
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
    }];
}


- (IBAction)logout:(id)sender {
    [MSAuth logout];
    [MSFolder MR_truncateAll];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSGalleryRollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSGalleryRollCell forIndexPath:indexPath];
    [cell setupWithModel:[self.contentArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
