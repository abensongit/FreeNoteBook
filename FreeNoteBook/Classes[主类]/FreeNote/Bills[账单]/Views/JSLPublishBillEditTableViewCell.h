

#import <UIKit/UIKit.h>
#import "JSLBillItemInfo.h"

@interface JSLPublishBillEditTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *valueTextField;

- (void)updateCellWithItemInfo:(JSLBillItemInfo *)info;

@end
