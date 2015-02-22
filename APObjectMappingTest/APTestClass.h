//
//  APTestClass.h
//  APObjectMapping
//
//  Created by Alexander Perechnev on 22.02.15.
//
//

#import <Foundation/Foundation.h>
#import "APTestRelatedClass.h"
#import "NSObject+APObjectMapping.h"


@interface APTestClass : NSObject

@property (nonatomic, strong) NSNumber * someNumber;
@property (nonatomic, strong) NSString * someString;
@property (nonatomic, strong) NSArray * someArray;
@property (nonatomic, strong) APTestRelatedClass * someRelated;

@end
