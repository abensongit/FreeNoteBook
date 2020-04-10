
#import <UIKit/UIKit.h>
#import "JSLFestivalItemInfo.h"

@interface JSLPublishFestivalEditTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *valueTextField;

- (void)updateCellWithItemInfo:(JSLFestivalItemInfo *)info;

@end
