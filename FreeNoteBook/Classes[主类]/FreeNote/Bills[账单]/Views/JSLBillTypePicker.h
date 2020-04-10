
#import <Foundation/Foundation.h>

@protocol JSLBillTypePickerDelegate <NSObject>

@optional

- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)pickerViewDidSelectType:(NSString *)type subType:(NSString *)subType;

@end

@interface JSLBillTypePicker : NSObject

@property (nonatomic, weak) id<JSLBillTypePickerDelegate> delegate;

- (void)show;

@end
