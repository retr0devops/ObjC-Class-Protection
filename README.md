
# Protection

This code provides a mechanism to protect Objective-C classes from unwanted modifications at runtime.

# How it works

The ProtectedClass implementation overrides the forwardInvocation: method, which is invoked when a message is sent to an object that doesn't respond to it. Instead of raising an exception, it retrieves the method that is being invoked, calculates its hash, and compares it with the original hash of the method. If they don't match, it exits the application.

The hash of a method is calculated using the SHA256 algorithm. To achieve this, the hashForMethod: function is defined. It retrieves the name of the method using the sel_getName and method_getName functions, converts it to a UTF-8 string, calculates its hash using CC_SHA256, and then creates a string representation of the hash.

# Usage

To use this code, simply import the Protection.h header file and create an instance of ProtectedClass. The class that you want to protect should inherit from ProtectedClass.

# Example

```objective-c
#import "Protection.h"

@interface MyProtectedClass : ProtectedClass
- (void)myMethod;
@end

@implementation MyProtectedClass
- (void)myMethod {
  NSLog(@"This is a protected method");
}
@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    MyProtectedClass *obj = [[MyProtectedClass alloc] init];
    [obj myMethod];
    [obj setValue:@"Hello" forKey:@"world"]; // Will exit the application
  }
  return 0;
}
```

# License

This code is licensed under the MIT License. See the LICENSE file for more information.
