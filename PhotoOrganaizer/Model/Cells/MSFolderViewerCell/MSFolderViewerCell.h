//
//  MSFolderViewerCell.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/21/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFolder.h"

@interface MSFolderViewerCell : UITableViewCell

- (void)setupWithModel: (MSFolder*)model;

@end
