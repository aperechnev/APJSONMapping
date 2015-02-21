/*
 Copyright (c) 2015, Alexander Perechnev
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "NSObject+APObjectMapping.h"


@implementation NSObject (APObjectMapping)

+ (NSMutableDictionary *)objectMapping {
  return [NSMutableDictionary new];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
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

@end
