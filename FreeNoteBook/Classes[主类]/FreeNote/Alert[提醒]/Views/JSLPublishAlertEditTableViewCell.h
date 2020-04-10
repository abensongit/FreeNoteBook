
#import <UIKit/UIKit.h>
#import "JSLAlertItemInfo.h"

@interface JSLPublishAlertEditTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *valueTextField;

- (void)updateCellWithItemInfo:(JSLAlertItemInfo *)info;

@end
