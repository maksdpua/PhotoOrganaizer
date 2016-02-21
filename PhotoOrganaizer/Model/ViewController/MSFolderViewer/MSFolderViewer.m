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
#import "MSDefaultFolderVC.h"
#import "MSCreateNewFolderView.h"
#import "MSGalleryRoll.h"

@interface MSFolderViewer()<UITableViewDelegate, UITableViewDataSource, MSRequestManagerDelegate, MSCreateNewFolderDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) MSCreateNewFolderView *createFolderItem;

@end

@implementation MSFolderViewer {
    NSArray *_contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
}


- (void)requestForData {
    if (!self.path) {
        self.path = @"";
    }
    NSDictionary *parameters = @{@"path" : self.path, @"recursive": @NO, @"include_media_info" : @NO, @"include_deleted" :@YES};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kListFolder] dictionaryParametrsToJSON: parameters classForFill:[MSFolder class] success:^(NSURLSessionDataTask *task, id responseObject) {
        MSFolder *folderContent = [MSFolder MR_findFirstByAttribute:@"path" withValue:self.path];
        NSArray *all = [MSFolder MR_findAll];
        for (MSFolder *f in all) {
            NSLog(@"Folder %@", f.nameOfFolder);
        }
        _contentArray = folderContent.folders.allObjects;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}



- (void)viewWillAppear:(BOOL)animated {
    [self requestForData];
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

- (IBAction)doneAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.path forKey:kDefaultFolderPath];
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDefaultFolderPath object:nil];
    }];
}

#pragma mark - UITableViewDelegate methdods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSFolderViewerCell *cell = [tableView dequeueReusableCellWithIdentifier:kMSFolderViewerCell];
    [cell setupWithModel:[_contentArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MSFolder *folderInfo = [_contentArray objectAtIndex:indexPath.row];
    MSFolderViewer *toNextFolder = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFolderViewer class])];
    toNextFolder.path = folderInfo.path;
    [self.navigationController pushViewController:toNextFolder animated:YES];
    
}


@end
