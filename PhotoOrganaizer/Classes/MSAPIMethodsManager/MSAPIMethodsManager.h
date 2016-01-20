//
//  MSAPIMethodsManager.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/20/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSRequestManager.h"

@interface MSAPIMethodsManager : MSRequestManager

- (void)createFolderWithPath:(NSString *)path;

- (void)getFolderContentWithPath:(NSString *)path;

@end
