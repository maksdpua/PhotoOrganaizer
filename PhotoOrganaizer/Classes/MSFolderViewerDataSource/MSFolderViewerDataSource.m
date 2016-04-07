//
//  MSFolderViewerDataSource.m
//  PhotoOrganaizer
//
//  Created by Maks on 4/6/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderViewerDataSource.h"
#import "MSRequestManager.h"
#import "MSFolderPathManager.h"

@interface MSFolderViewerDataSource()<MSRequestManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end

@implementation MSFolderViewerDataSource

#pragma mark - DataSource methods

- (instancetype)initWithDelegate:(id<MSFolderViewerDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.requestManager = [[MSRequestManager alloc] initWithDelegate:self];
        [self setupFetchedResultsController];
    }
    return self;
}

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [MSFolder MR_fetchAllSortedBy:@"nameOfFolder" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"folder.path == %@", [[MSFolderPathManager sharedManager] getLastPathInArray]] groupBy:nil delegate:self];
}

- (NSUInteger)countOfModels {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (MSPhoto *)modelAtIndex:(NSInteger)index {
    return self.fetchedResultsController.fetchedObjects[index];
}

- (void)removeModelAtIndex:(NSIndexPath *)indexPath {
    MSFolder *modelToRemove = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [modelToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

#pragma mark - NSFetchResult

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self setupFetchedResultsController];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.delegate respondsToSelector:@selector(contentWasChanged)]) {
        [self.delegate contentWasChanged];
    }
}


@end
