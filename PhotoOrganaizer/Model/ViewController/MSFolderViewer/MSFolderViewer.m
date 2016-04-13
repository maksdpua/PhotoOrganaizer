//
//  MSFolderViewer.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/21/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderViewer.h"
#import "MSFolderViewerCell.h"
#import "MSRequestManager.h"
#import "MSCreateNewFolderView.h"
#import "MSGalleryRoll.h"
#import "MSPhoto.h"
#import "MSThumbnail.h"
#import "MSFolderPathManager.h"
#import "MSAuth.h"
#import "MSFolderViewerDataSource.h"

@interface MSFolderViewer()<UITableViewDelegate, UITableViewDataSource, MSRequestManagerDelegate, MSFolderViewerDataSourceDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) MSCreateNewFolderView *createFolderItem;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong)MSFolderViewerDataSource *dataSource;

@end

@implementation MSFolderViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    self.dataSource = [[MSFolderViewerDataSource alloc]initWithDelegate:self];
    self.title = [[MSFolderPathManager sharedManager] getLastPathInArray];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestForData];
    [self tableViewBackgroundBlur];
    [self setBackgroundPhotoInTableView];
    
}

- (void)tableViewBackgroundBlur {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.tableView.frame;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView = blurEffectView;
}

- (void)setBackgroundPhotoInTableView {
    NSData *data = [self getRandomPhotoFromSelectedFolder];
    if (data) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithData:data]]];
    }
}

- (NSData *)getRandomPhotoFromSelectedFolder {
    MSThumbnail *thumbnail = [[MSThumbnail MR_findAll] lastObject];
    return thumbnail.data;
}

- (void)requestForData {
    NSDictionary *parameters = @{@"path" : [[MSFolderPathManager sharedManager] getLastPathInArray], @"recursive": @NO, @"include_media_info" : @YES, @"include_deleted" :@YES};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON:parameters classForFill:[MSFolder class] upload:^(NSProgress *uploadProgress) {
        
    } download:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        MSFolder *folderContent = [MSFolder MR_findFirstByAttribute:@"path" withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
        NSArray *fold = [MSFolder MR_findAllSortedBy:@"nameOfFolder" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"folder.path == %@", [[MSFolderPathManager sharedManager] getLastPathInArray]]];
//        self.contentArray = [self sortPhotosInArray:folderContent.folders.allObjects andKey:@"nameOfFolder"];
        self.contentArray = fold;
                NSArray *all = [MSFolder MR_findAll];
                for (MSFolder *f in all) {
                    NSLog(@"Folder %@", f.nameOfFolder);
                }
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)reloadDataAfterDismissCreateFolderView {
    [self requestForData];
}

#pragma mark - Actions

- (IBAction)createFolderAction:(id)sender {
    self.createFolderItem = [[MSCreateNewFolderView alloc]initOnView:self.navigationController.view andPath:[[MSFolderPathManager sharedManager] getLastPathInArray]];
}

- (IBAction)actionSheet:(id)sender {
    UIAlertController * actSheet=   [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
    
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
                             }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                                 [actSheet removeFromParentViewController];
                             }];

    

    [actSheet addAction:clearCache];
    [actSheet addAction:logout];
    [actSheet addAction:cancel];

    
    [self presentViewController:actSheet animated:YES completion:nil];
}
#pragma mark - UITableViewDelegate methdods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource countOfModels];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSFolderViewerCell *cell = [tableView dequeueReusableCellWithIdentifier:kMSFolderViewerCell];
    [cell setupWithModel:[self.dataSource modelAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MSFolder *folderInfo = [self.dataSource modelAtIndex:indexPath.row];
    [[MSFolderPathManager sharedManager] addEnteredFolderPath:folderInfo.path];
    MSFolderViewer *toNextFolder = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
    [self.navigationController pushViewController:toNextFolder animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[MSFolderPathManager sharedManager] removeLastPathInArray];
    }
    [super viewWillDisappear:animated];

}

#pragma mark - NSFolderViewerDataSourceDelegate methods

- (void)contentWasChanged {
    [self.tableView reloadData];
}


@end
