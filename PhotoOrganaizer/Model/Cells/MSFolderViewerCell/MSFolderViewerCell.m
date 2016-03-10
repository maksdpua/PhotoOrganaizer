//
//  MSFolderViewerCell.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/21/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderViewerCell.h"

@interface MSFolderViewerCell()

@property (nonatomic, weak) IBOutlet UIImageView *folderPicImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameFolderLabel;
@property (nonatomic, strong) NSString *pathToTheNextFolder;


@end

@implementation MSFolderViewerCell

- (void)setupWithModel:(MSFolder*)model {
    self.pathToTheNextFolder = model.path;
    self.nameFolderLabel.text = model.nameOfFolder;
    self.folderPicImageView.image = [UIImage folderPic];
}

- (IBAction)enterToTheNextFolder:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kEnterButtonWasPressed object:self.pathToTheNextFolder];
    
}



@end
