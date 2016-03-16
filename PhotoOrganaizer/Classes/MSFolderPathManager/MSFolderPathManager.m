//
//  MSFolderPathManager.m
//  PhotoOrganaizer
//
//  Created by Maks on 3/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "MSFolderPathManager.h"

@interface MSFolderPathManager()

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *idArray;

@end

@implementation MSFolderPathManager

+ (instancetype)sharedManager {
    static MSFolderPathManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pathArray = [NSMutableArray new];
        [self.pathArray addObject:@""];
    }
    return self;
}

- (void)addEnteredFolderPath:(NSString *)folderPath {
    [self.pathArray addObject:folderPath];
}

- (NSString *)getLastPathInArray {;
    NSLog(@"LAST PATH %@", [self.pathArray lastObject]);
    return [self.pathArray lastObject];
}

- (void)removeLastPathInArray {
    if ([[self.pathArray lastObject] isEqualToString:@""]) {
        NSLog(@"TRYING TO REMOVE FIRST OBJECT IN PATH ARRAY");
        return;
    }
    [self.pathArray removeLastObject];
}

@end
