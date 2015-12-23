//
//  NSObject+APJSONMapping.m
//  APJSONMapping
//
//  Created by Alexander Perechnev on 17.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import "NSObject+APJSONMapping.h"
#import <objc/objc-class.h>


@implementation NSObject (APJSONMapping)

+ (NSMutableDictionary *)objectMapping {
    return [NSMutableDictionary new];
}

#pragma mark - Dictionary mapping

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        NSDictionary *mappingRules = [[self class] objectMapping];
        
        for (NSString *propertyName in mappingRules) {
            id jsonFieldName = mappingRules[propertyName];
            Class propertyClass = [self classForPropertyNamed:propertyName];
            
            if (propertyClass == [NSArray class]) {
                NSString *sss = [NSString stringWithFormat:@"%@Type", propertyName];
                SEL sel = NSSelectorFromString(sss);
                if ([[self class] respondsToSelector:sel]) {
                    Class typeOfPropertyObjects = [[self class] performSelector:sel];
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in dictionary[jsonFieldName]) {
                        id obj = [[typeOfPropertyObjects alloc] initWithDictionary:dict];
                        [array addObject:obj];
                    }
                    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] capitalizedString], [propertyName substringFromIndex:1]]) withObject:array];
                    continue;
                }
            }
            
            BOOL isRelationship = [self classHasMapping:propertyClass];
            if (isRelationship == YES) {
                NSDictionary *childDictionary = dictionary[propertyName];
                Class relationClass = [self classForPropertyNamed:propertyName];
                [self setValue:[[relationClass alloc] initWithDictionary:childDictionary]
                    forKeyPath:propertyName];
                continue;
            }
            
            id value = dictionary[jsonFieldName];
            if ((value != nil) && ([value class] != [NSNull class])) {
                [self setValue:value forKey:propertyName];
            }
        }
    }
    return self;
}

- (Class)classForPropertyNamed:(NSString *)propertyName {
    objc_property_t property = class_getProperty([self class], propertyName.UTF8String);
    
    NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
    
    NSArray *attributeComponentList = [propertyAttributes componentsSeparatedByString:@"\""];
    if (attributeComponentList.count < 2) {
        return [NSObject class];
    }
    
    NSString *propertyClassName = [attributeComponentList objectAtIndex:1];
    Class propertyClass = NSClassFromString(propertyClassName);
    
    return propertyClass;
}

- (BOOL)classHasMapping:(Class)class {
    if (![class respondsToSelector:@selector(objectMapping)]) {
        return NO;
    }
    
    BOOL hasObjectMapping = ![[class objectMapping] isEqualToDictionary:@{}];
    if (hasObjectMapping) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)mapToDictionary {
    NSMutableDictionary *mappedDictionary = [NSMutableDictionary new];
    NSDictionary *objectMapping = [[self class] objectMapping];
    
    for (id objectKey in objectMapping) {
        id value = [self valueForKey:objectKey];
        if ([value isKindOfClass:[NSNull class]] == NO && value != nil) {
            BOOL isRelationship = [[[value class] objectMapping] isEqualToDictionary:@{}] == NO;
            if (isRelationship == YES) {
                NSDictionary *mappedSubDictionary = [value mapToDictionary];
                [mappedDictionary addEntriesFromDictionary:@{ objectKey: mappedSubDictionary }];
                continue;
            }
            
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Type", objectKey]);
            
            id dictionaryKey = objectMapping[objectKey];
            
            BOOL isArray = [value isKindOfClass:[NSArray class]];
            BOOL responds = [[self class] respondsToSelector:sel];
            
            BOOL isArrayRelation = isArray && responds;
            if (isArrayRelation) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *obj in value) {
                    if ([obj respondsToSelector:@selector(mapToDictionary)]) {
                        NSDictionary *dict = [obj mapToDictionary];
                        [array addObject:dict];
                    }
                }
                
                [mappedDictionary addEntriesFromDictionary:@{ dictionaryKey: array.copy }];
                continue;
            }
            
            [mappedDictionary addEntriesFromDictionary:@{ dictionaryKey: value }];
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
