
#import <UIKit/UIKit.h>

@interface JSLPlaceHolderTextView : UITextView

@property(nonatomic, copy) NSString *placeholder;

- (instancetype)initWithFrame:(CGRect)frame placeHolderPosition:(CGPoint)placeHolderPosition;

@end
