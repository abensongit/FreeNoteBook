
#import <Foundation/Foundation.h>

@interface JSLDeviceUtil : NSObject

@property (nonatomic, copy, readonly)   NSString *appName;
@property (nonatomic, copy, readonly)   NSString *appVersion;
@property (nonatomic, copy, readonly)   NSString *appBuildVersion;
@property (nonatomic, strong, readonly) UIImage  *appIcon;

+ (instancetype)sharedDevice;

@end
