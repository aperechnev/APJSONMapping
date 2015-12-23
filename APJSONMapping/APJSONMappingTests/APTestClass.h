//
//  APTestClass.h
//  APObjectMapping
//
//  Created by Alexander Perechnev on 22.02.15.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+APJSONMapping.h"
#import "APTestRelatedClass.h"


@interface APTestClass : NSObject

@property (nonatomic, strong) NSNumber *someNumber;
@property (nonatomic, strong) NSString *someString;
@property (nonatomic, strong) NSArray<NSNumber *> *someArray;
@property (nonatomic, strong) NSArray<APTestRelatedClass *> *someArrayOfRelatingObjects;
@property (nonatomic, strong) APTestRelatedClass *someRelated;

+ (Class)someArrayOfRelatingObjectsType;

@end
