//
//  APTestClass.m
//  APObjectMapping
//
//  Created by Alexander Perechnev on 22.02.15.
//
//

#import "APTestClass.h"


@implementation APTestClass

+ (NSMutableDictionary *)objectMapping {
  NSMutableDictionary * mapping = [super objectMapping];
  if (mapping) {
    NSDictionary * objectMapping = @{ @"someNumber": @"some_number",
                                      @"someString": @"some_string",
                                      @"someRelated": @"some_related",
                                      @"someArray": @"some_array" };
    [mapping addEntriesFromDictionary:objectMapping];
  }
  return mapping;
}

@end
