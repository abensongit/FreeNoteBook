

#import <UIKit/UIKit.h>

@protocol JSLBillHeaderViewDelegate <NSObject>

- (void)enterMonthBillWithMonth:(NSString *)month;

@end

@interface JSLBillHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<JSLBillHeaderViewDelegate> delegate;

- (void)updateViewWithTitle:(NSString *)title;

@end
