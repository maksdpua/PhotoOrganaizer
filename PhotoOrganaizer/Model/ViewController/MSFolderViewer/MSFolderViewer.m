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

static NSString *const kPreviousPath = @"previousPath";

@interface MSFolderViewer()<UITableViewDelegate, UITableViewDataSource, MSRequestManagerDelegate, MSCreateNewFolderDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) MSCreateNewFolderView *createFolderItem;
@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation MSFolderViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    
    [self tableViewBackgroundBlur];
    [self loadData];
    [self requestForData];
    [self setBackgroundPhotoInTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tableView.indexPathForSelectedRow) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
        [[MSFolderPathManager sharedManager] removeLastPathInArray];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToTheNextFolder:) name:kEnterButtonWasPressed object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)pushToTheNextFolder:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.tableView.indexPathForSelectedRow) {
        [[MSFolderPathManager sharedManager] removeLastPathInArray];
    }
    MSFolderViewer *toNextFolder = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
    toNextFolder.path = notification.object;
    [self.navigationController pushViewController:toNextFolder animated:YES];
//    [[NSUserDefaults standardUserDefaults] setObject:toNextFolder.path forKey:kDefaultFolderPath];
    if (![toNextFolder.path isEqualToString:[[MSFolderPathManager sharedManager] getLastPathInArray]]) {
        [[MSFolderPathManager sharedManager] addEnteredFolderPath:toNextFolder.path];
    }
    
}

- (NSData *)getRandomPhotoFromSelectedFolder {
    MSThumbnail *thumbnail = [[MSThumbnail MR_findAll] lastObject];
    return thumbnail.data;
}

- (void)requestForData {
//    [self checkForEmptyPath];
    NSDictionary *parameters = @{@"path" : [[MSFolderPathManager sharedManager] getLastPathInArray], @"recursive": @NO, @"include_media_info" : @NO, @"include_deleted" :@YES};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON: parameters classForFill:[MSFolder class] success:^(NSURLSessionDataTask *task, id responseObject) {
        MSFolder *folderContent = [MSFolder MR_findFirstByAttribute:@"path" withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
        NSArray *all = [MSFolder MR_findAll];
        for (MSFolder *f in all) {
            NSLog(@"Folder %@", f.nameOfFolder);
        }
        self.contentArray = folderContent.folders.allObjects;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadData {
//    [self checkForEmptyPath];
    MSFolder *folderContent = [MSFolder MR_findFirstByAttribute:@"path" withValue:[[MSFolderPathManager sharedManager] getLastPathInArray]];
    self.contentArray = folderContent.folders.allObjects;
    if (!self.contentArray) {
        [self requestForData];
    }
    
}

- (void)checkForEmptyPath {
    if (!self.path) {
        self.path = [NSString new];
        [[NSUserDefaults standardUserDefaults] setObject:self.path forKey:kDefaultFolderPath];
    };
}

- (void)reloadDataAfterDismissCreateFolderView {
    [self.navigationController setNavigationBarHidden:NO];
    [self requestForData];
}

- (IBAction)createFolderAction:(id)sender {
    [self.navigationController setNavigationBarHidden:YES];
    self.createFolderItem = [[MSCreateNewFolderView alloc]initOnView:self.view andPath:self.path];
    self.createFolderItem.delegate = self;
}

#pragma mark - UITableViewDelegate methdods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSFolderViewerCell *cell = [tableView dequeueReusableCellWithIdentifier:kMSFolderViewerCell];
    [cell setupWithModel:[self.contentArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MSFolder *folderInfo = [_contentArray objectAtIndex:indexPath.row];
    if (![[[MSFolderPathManager sharedManager] getLastPathInArray] isEqualToString:folderInfo.path]) {
        [[MSFolderPathManager sharedManager] addEnteredFolderPath:folderInfo.path];
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:folderInfo.path forKey:kDefaultFolderPath];
//    [[NSUserDefaults standardUserDefaults] setObject:self.path forKey:kPreviousPath];
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [[MSFolderPathManager sharedManager] removeLastPathInArray];
//}

- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[MSFolderPathManager sharedManager] removeLastPathInArray];
    }
    [super viewWillDisappear:animated];

}


@end
