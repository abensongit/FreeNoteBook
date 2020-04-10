
#import "JSLSysUserDefaults.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSLSysUserDefaults (Properties)

@property (nonatomic, weak) NSString *token;               // 系统Token
@property (nonatomic, weak) NSString *userId;              // 用户标识
@property (nonatomic, weak) NSString *userName;            // 用户名称
@property (nonatomic, weak) NSString *nickName;            // 用户名称
@property (nonatomic, weak) NSString *appversion;          // 系统版本

@property (nonatomic, assign) BOOL loginStatus;            // 登录状态

@property (nonatomic, weak) NSNumber *touchButtonOriginX;        // 悬浮按钮坐标X
@property (nonatomic, weak) NSNumber *touchButtonOriginY;        // 悬浮按钮坐标Y

@end

NS_ASSUME_NONNULL_END
