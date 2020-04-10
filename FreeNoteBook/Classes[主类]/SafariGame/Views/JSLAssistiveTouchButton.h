
#import "JSLAssistiveTouchComponent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JSLAssistiveTouchButtonDelegate;

@interface JSLAssistiveTouchButton : JSLAssistiveTouchComponent
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectImage;
@property (nonatomic, weak) id <JSLAssistiveTouchButtonDelegate> delegate;

+ (instancetype)spreadButtonWithCapacity:(NSUInteger)itemsNum;
- (void)spreadButtonDidClickItemAtIndex:(void(^)(NSUInteger index))indexBlock;

- (void)hitTestWithEventToShrinkCloseHandle;

@end

@protocol JSLAssistiveTouchButtonDelegate <NSObject>
@optional
- (void)touchButton:(JSLAssistiveTouchButton *)touchButton didSelectedAtIndex:(NSUInteger)index withSelectedButton:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
