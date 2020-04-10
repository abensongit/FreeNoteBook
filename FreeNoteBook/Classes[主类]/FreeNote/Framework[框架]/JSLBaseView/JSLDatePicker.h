
#import <Foundation/Foundation.h>

@protocol JSLDatePickerDelegate <NSObject>

@optional

- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)changeTime:(UIDatePicker *)datePicker;

@end

@interface JSLDatePicker : NSObject

@property (nonatomic, weak) id<JSLDatePickerDelegate> delegate;

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode;

- (void)setMinimumDate:(NSDate *)minimumDate;

- (void)show;

@end
