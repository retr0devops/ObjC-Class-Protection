#import "Protection.h"

static NSString * hashForMethod(Method method) {
  unsigned char digest[CC_SHA256_DIGEST_LENGTH];
  const char *methodUTF8String = sel_getName(method_getName(method));
  CC_SHA256(methodUTF8String, (CC_LONG)strlen(methodUTF8String), digest);
  NSMutableString *hash = ((NSMutableString *(*)(id, SEL, NSUInteger))objc_msgSend)([NSMutableString class], @selector(stringWithCapacity:), CC_SHA256_DIGEST_LENGTH * 2);
  for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
      [hash appendFormat:@"%02x", digest[i]];
  }
  return [hash copy];
}

@implementation ProtectedClass

- (void)swizzled_forwardInvocation:(NSInvocation *)anInvocation {
  Method method = class_getInstanceMethod(object_getClass(self), anInvocation.selector);
  NSString *originalHash = [self.originalHashes objectForKey:NSStringFromSelector(anInvocation.selector)];
  NSString *currentHash = hashForMethod(method);
  if (![originalHash isEqualToString:currentHash]) {
      exit(0);
      return;
  }
  IMP imp = class_getMethodImplementation(object_getClass(self), anInvocation.selector);
  void (*function)(id, SEL, NSInvocation *) = (__typeof__(function))imp;
  function(self, anInvocation.selector, anInvocation);
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.originalHashes = [NSMutableDictionary dictionary];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(self.class, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
      Method method = methodList[i];
      NSString *hash = hashForMethod(method);
      NSString *methodName = NSStringFromSelector(method_getName(method));
      [self.originalHashes setObject:hash forKey:methodName];
    }
    free(methodList);
  }
  return self;
}

@end
