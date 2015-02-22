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

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

// Test classes
#import "APTestClass.h"
#import "APTestSubclass.h"
#import "APTestRelatedClass.h"


@interface APObjectMappingTest : XCTestCase

@end


@implementation APObjectMappingTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testBaseClassMapping {
  APTestClass * testObject = [[APTestClass alloc] init];
  testObject.someNumber = @12345;
  testObject.someString = @"some test string";
  
  APTestClass * resultObject = [[APTestClass alloc] initWithDictionary:[testObject mapToDictionary]];
  XCTAssertEqualObjects(testObject.someNumber, resultObject.someNumber);
  XCTAssertEqualObjects(testObject.someString, resultObject.someString);
}

- (void)testSubclassMapping {
  APTestSubclass * testObject = [[APTestSubclass alloc] init];
  testObject.someNumber = @11111;
  testObject.someString = @"some string";
  testObject.anotherNumber = @22222;
  testObject.anotherString = @"another string";
  
  APTestSubclass * resultObject = [[APTestSubclass alloc] initWithDictionary:[testObject mapToDictionary]];
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
  
  APTestClass * resultObject = [[APTestClass alloc] initWithDictionary:[testObject mapToDictionary]];
  XCTAssertEqualObjects(testObject.someNumber, resultObject.someNumber);
  XCTAssertEqualObjects(testObject.someString, resultObject.someString);
  XCTAssertEqualObjects(testObject.someRelated.anyValue, resultObject.someRelated.anyValue);
}

- (void)testArrayMapping {
  APTestClass * testObject = [[APTestClass alloc] init];
  testObject.someArray = @[ @3, @1, @2 ];
  
  APTestClass * resultObject = [[APTestClass alloc] initWithDictionary:[testObject mapToDictionary]];
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
  
  testObject.someArray = @[ testRelatedObject1, testRelatedObject2 ];
  
  APTestClass * resultObject = [[APTestClass alloc] initWithDictionary:[testObject mapToDictionary]];
  XCTAssertEqual(testObject.someArray.count, resultObject.someArray.count);

  APTestRelatedClass * resultRelatedObject1 = resultObject.someArray[0];
  APTestRelatedClass * resultRelatedObject2 = resultObject.someArray[1];
  
  XCTAssertEqualObjects(testRelatedObject1.anyValue, resultRelatedObject1.anyValue);
  XCTAssertEqualObjects(testRelatedObject2.anyValue, resultRelatedObject2.anyValue);
}

@end
