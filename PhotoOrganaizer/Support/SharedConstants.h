//
//  SharedConstants.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/9/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#ifndef SharedConstants_h
#define SharedConstants_h

static NSString *const kToken = @"token";
static NSString *const kUID = @"uid";

static NSString *const kAuthURLwasAccepted = @"authURLWasAccepted";
static NSString *const kReloadNC = @"reloadNC";
static NSString *const kTokenWasAccepted = @"tokenWasAccepted";
static NSString *const kUIDwasAccepted = @"uidWasAccepted";

static NSString *const KMainURL = @"https://api.dropboxapi.com/2/";
static NSString *const kContentURL = @"https://content.dropboxapi.com/2/";
static NSString *const kListFolder = @"files/list_folder";
static NSString *const kCreateFolder = @"files/create_folder";
static NSString *const kDownload = @"files/download";
static NSString *const kUpload = @"files/upload";
static NSString *const kGetThumbnail = @"files/get_thumbnail";


static NSString *const kFolderPic = @"blackfolder";

static NSString *const kMSFolderViewerCell = @"MSFolderViewerCell";
static NSString *const kMSGalleryRollCell = @"MSGalleryRollCell";
static NSString *const kMSGalleryRollLoadCell = @"MSGalleryRollLoadCell";

#pragma mark - CoreDataModelsEntriesKeys

static NSString *const kID = @"id";
static NSString *const kPathLower = @"path_lower";
static NSString *const kDotTag = @".tag";
static NSString *const kName = @"name";
static NSString *const kPath = @"path";
static NSString *const kTag = @"tag";

static NSString *const kStringRecevied = @"stringRecevied";
static NSString *const kDefaultFolderPath = @"defaultFolderPath";
static NSString *const kPhotosWasSelected = @"photosWasSelected";


#define urlPath(mainURL, secondURL) [NSString stringWithFormat: @"%@%@", mainURL, secondURL]



#endif /* SharedConstants_h */
