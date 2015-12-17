//
//  APTestSubclass.m
//  APObjectMapping
//
//  Created by Alexander Perechnev on 22.02.15.
//
//

#import "APTestSubclass.h"


@implementation APTestSubclass

+ (NSMutableDictionary *)objectMapping {
  NSMutableDictionary * mapping = [super objectMapping];
  if (mapping) {
    NSDictionary * objectMapping = @{ @"anotherNumber": @"another_number",
                                      @"anotherString": @"another_string" };
    [mapping addEntriesFromDictionary:objectMapping];
  }
  return mapping;
}

@end
