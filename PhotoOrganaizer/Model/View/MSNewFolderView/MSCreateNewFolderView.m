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

@end

@implementation MSCreateNewFolderView

- (instancetype)initOnView:(UIView *)view {
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    if (self) {
        self.frame = view.frame;
        self.requestManager = [[MSRequestManager alloc] initWithDelegate:self];
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

- (void)createFolderWithName:(NSString *)name {
    NSDictionary *parametrs = @{@"path" : name};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"%@%@", KMainURL, kCreateFolder] dictionaryParametrsToJSON:parametrs classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self removeFromSuperview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
