
#import <UIKit/UIKit.h>

@protocol JSLSettingHeaderViewDelegate <NSObject>

- (void)showBigHighDefinitionImage;

@end

@interface JSLSettingHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<JSLSettingHeaderViewDelegate> delegate;

- (void)updateViewWithImage:(UIImage *)image;

@end
