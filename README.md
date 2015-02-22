# APObjectMapping
Objective-C class extension which allows you to easily map your objects to dictionaries and parse your objects from dictionaries.

## Installation

To install APObjectMapping, just copy and add this files into your project:

1. NSObject+APObjectMapping.h
2. NSObject+APObjectMapping.m

When files are added, just import the Objective-C category to add appropriate functionality to your existing classes:

    #import <Foundation/Foundation.h>
    #import "NSObject+APObjectMapping.h"
    
    @interface MyCustomClass : NSObject
    // ...
    @end
