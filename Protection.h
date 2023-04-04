#import <sys/sysctl.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h>

@interface ProtectedClass : NSObject
@property NSMutableDictionary * originalHashes;
@end
