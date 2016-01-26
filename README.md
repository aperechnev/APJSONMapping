# APJSONMapping

[![Join the chat at https://gitter.im/alexkrzyzanowski/APJSONMapping](https://badges.gitter.im/alexkrzyzanowski/APJSONMapping.svg)](https://gitter.im/alexkrzyzanowski/APJSONMapping?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/alexkrzyzanowski/APJSONMapping.svg?branch=master)](https://travis-ci.org/alexkrzyzanowski/APJSONMapping)
[![CocoaPods](https://img.shields.io/cocoapods/v/APJSONMapping.svg)](https://cocoapods.org/pods/APJSONMapping)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/APJSONMapping.svg)](https://cocoapods.org/pods/APJSONMapping)
[![codecov.io](https://codecov.io/github/alexkrzyzanowski/APJSONMapping/coverage.svg?branch=develop)](https://codecov.io/github/alexkrzyzanowski/APJSONMapping?branch=develop)

An Objective-C class extension which allows you to easily map your objects to JSON string and parse your objects back from JSON.

## Installation

The easiest way to get `APJSONMapping` is to install it via CocoaPods:

```Podfile
target 'MyApp' do
  pod 'APJSONMapping', '~> 1.0'
end
```

When the framework installed, just import it to add appropriate functionality to your existing classes:

```objective-c
@import APJSONMapping;

@interface MyCustomClass : NSObject
// ...
@end
```

## Usage Example

To make your object able to be mapped to (and parsed from) JSON, you have to describe it's mapping rules:

```objective-c
@import Foundation;
@import APJSONMapping;

//
// Here is interface
@interface MyCustomClass : NSObject

@property (nonatomic, strong) NSNumber *someNumber;
@property (nonatomic, strong) NSString *someString;

+ (Class)someArrayOfRelatingObjectsType;
@end

//
// And here is implementation
@implementation MyCustomClass

+ (NSMutableDictionary *)ap_objectMapping {
  NSMutableDictionary * mapping = [super ap_objectMapping];
  if (mapping) {
    NSDictionary * objectMapping = @{ @"someNumber": @"some_number",
                                      @"someString": @"some_string"};
    [mapping addEntriesFromDictionary:objectMapping];
  }
  return mapping;
}

@end
```

Since you've described the mapping, you can map your object to JSON and parse it back:

```objective-c
MyCustomClass *myObject = [[MyCustomClass alloc] init];
myObject.someNumber = @112;
myObject.someString = @"testString";

NSString *json = [myObject ap_mapToJSONString]; // { "some_number": 112, "some_string": "testString" }
MyCustomClass *anotherObject = [[MyCustomClass alloc] initWithJSONString_ap:json];
```

## Code Coverage

![codecov.io](https://codecov.io/github/alexkrzyzanowski/APJSONMapping/branch.svg?branch=develop)
