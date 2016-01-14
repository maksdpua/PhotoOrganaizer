//
//  NSDictionary+DictionaryToJSON.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/13/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "NSDictionary+DictionaryToJSON.h"

@implementation NSDictionary (DictionaryToJSON)

+ (NSString *)convertDictionaryToJSONstringWith: (NSDictionary *)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:2
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:4];
    
    return jsonString;
}

@end
