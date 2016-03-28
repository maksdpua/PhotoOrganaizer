//
//  MSGalleryRollDataSource.m
//  PhotoOrganaizer
//
//  Created by Maks on 3/27/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSGalleryRollDataSource.h"
#import "MSRequestManager.h"
#import "MSFolderPathManager.h"
#import "MSFolder.h"
#import "MSPhoto.h"
#import "MSCache.h"

@interface MSGalleryRollDataSource()<MSRequestManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MSGalleryRollDataSource

- (instancetype)initWithDelegate:(id<MSGalleryRollDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.requestManager = [[MSRequestManager alloc] initWithDelegate:self];
        [self setupFetchedResultsController];
    }
    return self;
}

#pragma mark - DataSource methods

- (void)setupFetchedResultsController {
    self.contentArray = [NSMutableArray new];
    self.fetchedResultsController = [MSPhoto MR_fetchAllSortedBy:@"clientModified" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"toFolder.path == %@", [[MSFolderPathManager sharedManager] getLastPathInArray]] groupBy:nil delegate:self];
    [self.contentArray addObjectsFromArray:self.fetchedResultsController.fetchedObjects];
}

- (NSUInteger)countOfModels {
    return self.contentArray.count;
}

- (MSPhoto *)modelAtIndex:(NSInteger)index {
    return self.contentArray[index];
}

- (void)removeModelAtIndex:(NSIndexPath *)indexPath {
    MSPhoto *modelToRemove = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [modelToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)addNewDataObjectToUpload {
    
}

- (void)addNewObjectsWithArray:(NSMutableArray *)objectsArray {
    for (NSDictionary *dataDic in objectsArray) {
        
        MSPhoto *newPhoto = [MSPhoto MR_createEntity];
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[MSFolderPathManager sharedManager]getLastPathInArray],[dataDic valueForKey:@"imageName"]];
        [newPhoto setValue:path forKey:@"path"];
        [newPhoto checkForBackFolderAndAddWith:path photoObject:newPhoto];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        NSDictionary *param = @{@"path" : path, @"mode" : @"add", @"autorename" : @YES, @"mute" : @NO};
        [self.requestManager createRequestWithPOSTmethodWithFileUpload:[dataDic valueForKey:@"imageData"] stringURL:[NSString stringWithFormat:@"%@files/upload", kContentURL] dictionaryParametrsToJSON:param classForFill:[MSPhoto class] upload:^(NSProgress *uploadProgress) {

        } download:^(NSProgress *downloadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            MSPhoto *photo = responseObject;
            MSCache *cache = [[MSCache alloc]init];
            [cache cacheForImageWithKey:photo completeBlock:^(NSData *responseData) {
                
            } errorBlock:^(NSError *error) {
                
            }];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
        
        
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self setupFetchedResultsController];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.delegate respondsToSelector:@selector(contentWasChanged)]) {
        [self.delegate contentWasChanged];
    }
    
}


@end
