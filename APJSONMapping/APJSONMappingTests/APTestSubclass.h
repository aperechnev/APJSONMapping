//
//  APTestSubclass.h
//  APObjectMapping
//
//  Created by Alexander Perechnev on 22.02.15.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+APJSONMapping.h"
#import "APTestClass.h"


@interface APTestSubclass : APTestClass

@property (nonatomic, strong) NSNumber *anotherNumber;
@property (nonatomic, strong) NSString *anotherString;

@end
