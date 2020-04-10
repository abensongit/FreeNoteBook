
#import <UIKit/UIKit.h>
#import "JSLDiaryInfo.h"

static NSString *diaryUpdateSuccessNotification = @"diaryUpdateSuccessNotification";

@interface JSLDiaryEditViewController : JSLBaseCommonViewController

@property (nonatomic, strong) JSLDiaryInfo *diaryInfo;

@end
