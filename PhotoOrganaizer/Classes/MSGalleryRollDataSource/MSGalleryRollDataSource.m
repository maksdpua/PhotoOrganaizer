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

@interface MSGalleryRollDataSource()<MSRequestManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;

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

#pragma mark - DataSOurce methods

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [MSFolder MR_fetchAllSortedBy:@"" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"path == %@", [[MSFolderPathManager sharedManager] getLastPathInArray]] groupBy:nil delegate:self];
}

- (NSUInteger)countOfModels {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (MSPhoto *)modelAtIndex:(NSInteger)index {
    return self.fetchedResultsController.fetchedObjects[index];
}

- (void)removeModelAtIndex:(NSIndexPath *)indexPath {
    MSPhoto *modelToRemove = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [modelToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
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
