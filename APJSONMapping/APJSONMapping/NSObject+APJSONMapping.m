//
//  NSObject+APJSONMapping.m
//  APJSONMapping
//
//  Created by Alex Krzyżanowski on 17.12.15.
//  Copyright © 2015 Alex Krzyżanowski. All rights reserved.
//

#import "NSObject+APJSONMapping.h"
#import <objc/objc-class.h>


@implementation NSObject (APJSONMapping)

+ (NSMutableDictionary *)ap_objectMapping {
    return [NSMutableDictionary new];
}

#pragma mark - Dictionary mapping

- (instancetype)initWithDictionary_ap:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        NSDictionary *mappingRules = [[self class] ap_objectMapping];
        
        for (NSString *propertyName in mappingRules) {
            id jsonFieldName = mappingRules[propertyName];
            Class propertyClass = [self ap_classForPropertyNamed:propertyName];
            
            if (propertyClass == [NSArray class]) {
                NSString *sss = [NSString stringWithFormat:@"%@Type", propertyName];
                SEL sel = NSSelectorFromString(sss);
                if ([[self class] respondsToSelector:sel]) {
                    Class typeOfPropertyObjects = [[self class] performSelector:sel];
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in dictionary[jsonFieldName]) {
                        id obj = [[typeOfPropertyObjects alloc] initWithDictionary_ap:dict];
                        [array addObject:obj];
                    }
                    [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] capitalizedString], [propertyName substringFromIndex:1]]) withObject:array];
                    continue;
                }
            }
            
            BOOL isRelationship = [self ap_classHasMapping:propertyClass];
            if (isRelationship == YES) {
                NSDictionary *childDictionary = dictionary[propertyName];
                Class relationClass = [self ap_classForPropertyNamed:propertyName];
                [self setValue:[[relationClass alloc] initWithDictionary_ap:childDictionary]
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

- (Class)ap_classForPropertyNamed:(NSString *)propertyName {
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

- (BOOL)ap_classHasMapping:(Class)class {
    BOOL hasObjectMapping = ![[class ap_objectMapping] isEqualToDictionary:@{}];
    if (hasObjectMapping) {
        return YES;
    }
    
    return NO;
}

- (NSDictionary *)ap_mapToDictionary {
    NSMutableDictionary *mappedDictionary = [NSMutableDictionary new];
    NSDictionary *objectMapping = [[self class] ap_objectMapping];
    
    for (id objectKey in objectMapping) {
        id value = [self valueForKey:objectKey];
        if ([value isKindOfClass:[NSNull class]] == NO && value != nil) {
            BOOL isRelationship = [[[value class] ap_objectMapping] isEqualToDictionary:@{}] == NO;
            if (isRelationship == YES) {
                NSDictionary *mappedSubDictionary = [value ap_mapToDictionary];
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
                    if ([obj respondsToSelector:@selector(ap_mapToDictionary)]) {
                        NSDictionary *dict = [obj ap_mapToDictionary];
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

- (instancetype)initWithJSONString_ap:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    return [self initWithDictionary_ap:dictionary];
}

- (NSString *)ap_mapToJSONString {
    NSDictionary *dictionary = [self ap_mapToDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

@end
