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
#import "MSThumbnail.h"

@interface MSGalleryRollDataSource()<MSRequestManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSRequestManager *requestManager;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *uploadObjectsInProgressDataBase;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation MSGalleryRollDataSource

- (instancetype)initWithDelegate:(id<MSGalleryRollDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.uploadObjectsInProgressDataBase = [NSMutableArray new];
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


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
        if ([self.delegate respondsToSelector:@selector(contentWasChangedAtIndex:)]) {
            [self.delegate contentWasChangedAtIndex:sectionIndex];
        }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self setupFetchedResultsController];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.delegate respondsToSelector:@selector(contentWasChangedAtIndexPath:forChangeType:newIndexPath:)]) {
        [self.delegate contentWasChangedAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
    
}


@end
