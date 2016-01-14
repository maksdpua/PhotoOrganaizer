//
//  NSDictionary+DictionaryToJSON.h
//  PhotoOrganaizer
//
//  Created by Maks on 1/13/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DictionaryToJSON)

+ (NSString *)convertDictionaryToJSONstringWith: (NSDictionary *)dictionary;

@end
