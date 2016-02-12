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

@interface MSFolderViewer()<UITableViewDelegate, UITableViewDataSource, MSRequestManagerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MSRequestManager *requestManager;


@end

@implementation MSFolderViewer {
    
    NSArray *_contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    [self requestForData];
    
}

- (void)requestForData {
    NSLog(@"Self Path %@", self.path);
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
    [self addOKbuttonOnNavBar];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)addOKbuttonOnNavBar {
    UIBarButtonItem *btnSave = [[UIBarButtonItem alloc]
                                initWithTitle:@"OK"
                                style:UIBarButtonItemStyleDone
                                target:self
                                action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = btnSave;
}

- (void)doneAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDefaultFolderPath object:self.path];
    for (id controller in [self.navigationController viewControllers]) {
        if ([controller isKindOfClass:[MSDefaultFolderVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
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
