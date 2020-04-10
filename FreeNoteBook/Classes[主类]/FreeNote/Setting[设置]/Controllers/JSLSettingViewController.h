
#import "JSLBaseCommonViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIView+JSLTips.h"

typedef NS_ENUM(NSUInteger, JSLSettingHeadImageType) {
    kJSLSettingHeadImageTypeCamera,
    kJSLSettingHeadImageTypeAlbum,
};

@interface JSLSettingViewController : JSLBaseCommonViewController

@end
