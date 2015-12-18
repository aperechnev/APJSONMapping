//
//  NSObject+APJSONMapping.m
//  APJSONMapping
//
//  Created by Alexander Perechnev on 17.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "NSObject+APJSONMapping.h"


@implementation NSObject (APJSONMapping)

+ (NSMutableDictionary *)objectMapping {
    return [NSMutableDictionary new];
}

#pragma mark - Dictionary mapping

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        NSDictionary * objectMapping = [[self class] objectMapping];
        for (id objectKey in objectMapping) {
            id dictionaryKey = objectMapping[objectKey];
            
            BOOL isRelationship = [dictionaryKey isKindOfClass:[NSArray class]];
            if (isRelationship == YES) {
                NSArray * relationshipMapping = (NSArray *)dictionaryKey;
                NSString * relationDictionaryKey = relationshipMapping[0];
                Class relationClass = relationshipMapping[1];
                id value = dictionary[relationDictionaryKey];
                if (value != nil && [value class] != [NSNull class]) {
                    [self setValue:[[relationClass alloc] initWithDictionary:value] forKeyPath:objectKey];
                }
            }
            else {
                id value = dictionary[dictionaryKey];
                if ((value != nil) && ([value class] != [NSNull class])) {
                    [self setValue:value forKey:objectKey];
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)mapToDictionary {
    NSMutableDictionary * mappedDictionary = [NSMutableDictionary new];
    
    NSDictionary * objectMapping = [[self class] objectMapping];
    for (id objectKey in objectMapping) {
        id value = [self valueForKey:objectKey];
        if ([value isKindOfClass:[NSNull class]] == NO && value != nil) {
            BOOL isRelationship = [value respondsToSelector:@selector(objectMapping)];
            if (isRelationship == YES) {
                id dictionaryKey = objectMapping[objectKey][0];
                NSDictionary * mappedSubDictionary = [(NSObject *)value mapToDictionary];
                [mappedDictionary addEntriesFromDictionary:@{ dictionaryKey: mappedSubDictionary }];
            }
            else {
                id dictionaryKey = objectMapping[objectKey];
                [mappedDictionary addEntriesFromDictionary:@{ dictionaryKey: value }];
            }
        }
    }
    
    return mappedDictionary;
}

#pragma mark - JSON mapping

- (instancetype)initWithJSONString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    return [self initWithDictionary:dictionary];
}

- (NSString *)mapToJSONString {
    NSDictionary *dictionary = [self mapToDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

@end
