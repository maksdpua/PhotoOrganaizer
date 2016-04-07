//
//  NSObject+Extension.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FillingClassProtocol

@optional

- (instancetype) initClassWithDictionary: (NSDictionary *)dictionary;

@end

@interface NSObject (Extension) <FillingClassProtocol>

- (instancetype)loadClassWithDictionary:(NSDictionary *)dictionary InstructionDictionary:(NSDictionary *)instruction;

- (void)printDescription;

- (NSArray *)sortPhotosInArray:(NSArray *)array andKey:(NSString *)key;

- (NSString *)checkForBackFolderInPath:(NSString *)path;

@end

