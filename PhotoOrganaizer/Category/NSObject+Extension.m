//
//  NSObject+Extension.m
//  PhotoOrganaizer
//
//  Created by Maks on 1/7/16.
//  Copyright © 2016 Maks. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (instancetype)loadClassWithDictionary:(NSDictionary *)dictionary InstructionDictionary:(NSDictionary *)instruction {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *propertyName = [instruction valueForKey:key];
        if (propertyName && ![[obj class] isSubclassOfClass:[NSNull class]]) {
            if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
                [self setValue:[NSString stringWithFormat:@"%@", obj] forKey:propertyName];
            } else {
                [self setValue:obj forKey:propertyName];
            }
        }
    }];
    return self;
}

- (void)printDescription {
    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionary];
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:propertyName];
        if (value)
            propertyValues[propertyName] = value;
        else
            propertyValues[propertyName] = @"nil";
    }
    free(properties);
    NSLog(@"%@", [NSString stringWithFormat:@"\n%@:\n%@", self.class, propertyValues]);
}




@end
