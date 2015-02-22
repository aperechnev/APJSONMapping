# APObjectMapping

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

## License

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
