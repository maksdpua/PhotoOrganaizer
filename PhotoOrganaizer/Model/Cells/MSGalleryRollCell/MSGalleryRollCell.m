//
//  MSGalleryRollCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 2/12/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollCell.h"
#import <AFNetworking/AFNetworking.h>
#import "UIKit+AFNetworking.h"
#import "MSRequestManager.h"

@interface MSGalleryRollCell()<MSRequestManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, strong) MSRequestManager *requestManager;

@end

@implementation MSGalleryRollCell

- (void)setupWithModel:(MSPhoto *)model {
    self.requestManager = [[MSRequestManager alloc]initWithDelegate:self];
    NSDictionary *paramerts = @{@"path" : model.path, @"format" : [model.namePhoto pathExtension], @"size" : @"w64h64"};
    [self.requestManager createRequestWithPOSTmethodWithAuthAndJSONbodyAtURL:[NSString stringWithFormat:@"https://content.dropboxapi.com/2/files/get_thumbnail"] dictionaryParametrsToJSON:paramerts classForFill:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"REPONSE %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR %@" , error);
    }];
    [self.photo setImageWithURL:[NSURL URLWithString:model.path]];
}



@end
