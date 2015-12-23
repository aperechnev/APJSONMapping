//
//  APJSONMappingTests.m
//  APJSONMappingTests
//
//  Created by Alexander Perechnev on 17.12.15.
//  Copyright © 2015 Alexander Perechnev. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSObject+APJSONMapping.h"
#import "APTestClass.h"
#import "APTestSubclass.h"
#import "APTestRelatedClass.h"


@interface APJSONMappingTests : XCTestCase

@end


@implementation APJSONMappingTests

- (void)testBaseMapping {
    APTestClass *sourceObject = [[APTestClass alloc] init];
    sourceObject.someNumber = @112;
    sourceObject.someString = @"testString";
    
    NSString *json = [sourceObject mapToJSONString];
    APTestClass *testObject = [[APTestClass alloc] initWithJSONString:json];
    XCTAssertEqualObjects(testObject.someNumber, sourceObject.someNumber);
    XCTAssertEqualObjects(testObject.someString, sourceObject.someString);
}

- (void)testSubclassMapping {
    APTestSubclass * testObject = [[APTestSubclass alloc] init];
    testObject.someNumber = @11111;
    testObject.someString = @"some string";
    testObject.anotherNumber = @22222;
    testObject.anotherString = @"another string";
    
    APTestSubclass * resultObject = [[APTestSubclass alloc] initWithJSONString:[testObject mapToJSONString]];
    XCTAssertEqualObjects(testObject.someNumber, resultObject.someNumber);
    XCTAssertEqualObjects(testObject.someString, resultObject.someString);
    XCTAssertEqualObjects(testObject.anotherNumber, resultObject.anotherNumber);
    XCTAssertEqualObjects(testObject.anotherString, resultObject.anotherString);
}

- (void)testClassRelations {
    APTestRelatedClass * relatedObject = [[APTestRelatedClass alloc] init];
    relatedObject.anyValue = @"any string haha :)";
    
    APTestClass * testObject = [[APTestClass alloc] init];
    testObject.someNumber = @12345;
    testObject.someString = @"some string";
    testObject.someRelated = relatedObject;
    
    NSString *jsonString = [testObject mapToJSONString];
    APTestClass * resultObject = [[APTestClass alloc] initWithJSONString:jsonString];
    XCTAssertEqualObjects(testObject.someNumber, resultObject.someNumber);
    XCTAssertEqualObjects(testObject.someString, resultObject.someString);
    XCTAssertEqualObjects(testObject.someRelated.anyValue, resultObject.someRelated.anyValue);
}

- (void)testArrayMapping {
    APTestClass * testObject = [[APTestClass alloc] init];
    testObject.someArray = @[ @3, @1, @2 ];
    
    APTestClass * resultObject = [[APTestClass alloc] initWithJSONString:[testObject mapToJSONString]];
    XCTAssertEqualObjects(testObject.someArray[0], resultObject.someArray[0]);
    XCTAssertEqualObjects(testObject.someArray[1], resultObject.someArray[1]);
    XCTAssertEqualObjects(testObject.someArray[2], resultObject.someArray[2]);
}

- (void)testArrayRelation {
    APTestClass * testObject = [[APTestClass alloc] init];
    
    APTestRelatedClass * testRelatedObject1 = [[APTestRelatedClass alloc] init];
    testRelatedObject1.anyValue = @"first";
    
    APTestRelatedClass * testRelatedObject2 = [[APTestRelatedClass alloc] init];
    testRelatedObject2.anyValue = @"second";
    
    testObject.someArrayOfRelatingObjects = @[ testRelatedObject1, testRelatedObject2 ];
    
    APTestClass * resultObject = [[APTestClass alloc] initWithJSONString:[testObject mapToJSONString]];
    XCTAssertEqual(testObject.someArrayOfRelatingObjects.count, resultObject.someArrayOfRelatingObjects.count);
    
    APTestRelatedClass * resultRelatedObject1 = resultObject.someArrayOfRelatingObjects[0];
    APTestRelatedClass * resultRelatedObject2 = resultObject.someArrayOfRelatingObjects[1];
    
    XCTAssertEqualObjects(testRelatedObject1.anyValue, resultRelatedObject1.anyValue);
    XCTAssertEqualObjects(testRelatedObject2.anyValue, resultRelatedObject2.anyValue);
}

@end
