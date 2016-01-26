# APObjectMapping

[![Join the chat at https://gitter.im/alexkrzyzanowski/APJSONMapping](https://badges.gitter.im/alexkrzyzanowski/APJSONMapping.svg)](https://gitter.im/alexkrzyzanowski/APJSONMapping?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/alexkrzyzanowski/APJSONMapping.svg?branch=master)](https://travis-ci.org/alexkrzyzanowski/APJSONMapping)
[![CocoaPods](https://img.shields.io/cocoapods/v/APJSONMapping.svg)](https://cocoapods.org/pods/APJSONMapping)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/APJSONMapping.svg)](https://cocoapods.org/pods/APJSONMapping)
[![codecov.io](https://codecov.io/github/alexkrzyzanowski/APJSONMapping/coverage.svg?branch=develop)](https://codecov.io/github/alexkrzyzanowski/APJSONMapping?branch=develop)

Objective-C class extension which allows you to easily map your objects to dictionaries and parse your objects from dictionaries.

## Installation

To install APObjectMapping, just copy and add this files into your project:

1. NSObject+APObjectMapping.h
2. NSObject+APObjectMapping.m

When files are added, just import the Objective-C category to add appropriate functionality to your existing classes:

```objective-c
#import <Foundation/Foundation.h>
#import "NSObject+APObjectMapping.h"

@interface MyCustomClass : NSObject
// ...
@end
```

## Usage Example

To make your object able to be mapped to (and parsed from) dictionary, you have to describe it's mapping rules:

```objective-c
#import <Foundation/Foundation.h>
#import "NSObject+APObjectMapping.h"

@interface MyCustomClass : NSObject
@property (nonatomic, strong) NSNumber * someNumber;
@property (nonatomic, strong) NSString * someString;
@end

@implementation MyCustomClass
+ (NSMutableDictionary *)objectMapping {
  NSMutableDictionary * mapping = [super objectMapping];
  if (mapping) {
    NSDictionary * objectMapping = @{ @"someNumber": @"some_number",
                                      @"someString": @"some_string" };
    [mapping addEntriesFromDictionray:objectMapping];
  }
  return mapping
}
@end
```

Since you've described the mapping, you can map your object to dictionary:

```objective-c
MyCustomClass * myObj = [[MyCustomClass alloc] init];
myObj.someNumber = @1;
myObj.someString = @"some string";
NSDictionary * myDict = [myObj mapToDictionary];
```

You also can parse your object from dictionaries following the same way:

```objective-c
NSDictionary * myDict = @{ @"some_number": @123,
                           @"some_string": @"some_string" };
MyCustomClass * myObj = [[MyCustomClass alloc] initWithDictionary:myDict];
```

## Code Coverage

![codecov.io](https://codecov.io/github/alexkrzyzanowski/APJSONMapping/branch.svg?branch=develop)
