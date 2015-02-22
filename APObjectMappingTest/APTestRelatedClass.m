//
//  APTestRelatedClass.m
//  APObjectMapping
//
//  Created by Alexander Perechnev on 22.02.15.
//
//

#import "APTestRelatedClass.h"
#import "NSObject+APObjectMapping.h"


@implementation APTestRelatedClass

+ (NSMutableDictionary *)objectMapping {
  NSMutableDictionary * mapping = [super objectMapping];
  if (mapping) {
    NSDictionary * objectMapping = @{ @"anyValue": @"any_value" };
    [mapping addEntriesFromDictionary:objectMapping];
  }
  return mapping;
}

@end
