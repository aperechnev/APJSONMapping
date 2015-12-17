//
//  NSObject+APJSONMapping.h
//  APJSONMapping
//
//  Created by Alexander Perechnev on 17.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (APJSONMapping)

+ (NSMutableDictionary *)objectMapping;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)mapToDictionary;
@end
