//
//  MSFolderNewFolderView.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/16/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSCreateNewFolderView.h"
#import "MSRequestManager.h"

@interface MSCreateNewFolderView()<MSRequestManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *folderName;
@property (nonatomic, weak) IBOutlet UIButton *createButton;
@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSString *folderPath;

@end

@implementation MSCreateNewFolderView

- (instancetype)initOnView:(UIView *)view andPath:(NSString *)path {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    if (self) {
        self.frame = view.frame;
        self.requestManager = [[MSRequestManager alloc] initWithDelegate:self];
        self.folderPath = path;
        [view addSubview:self];
        [self showWithDuration:0.25 withAlpha:1];
    }
    return self;
}

- (void)showWithDuration:(CGFloat)duration withAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = alpha;
    }];
}

- (void)createFolderWithName {
    NSDictionary *parametrs = @{@"path" : [NSString stringWithFormat:@"%@/%@", self.folderPath, self.folderName.text]};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kCreateFolder] dictionaryParametrsToJSON:parametrs classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success %@", responseObject);
        [self.delegate reloadDataAfterDismissCreateFolderView];
        [self removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR %@", error);
        [self removeFromSuperview];
    }];
}

- (IBAction)creafolder:(id)sender {
    [self createFolderWithName];
}



@end
