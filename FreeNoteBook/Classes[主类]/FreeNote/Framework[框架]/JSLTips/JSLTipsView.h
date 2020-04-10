
#import <UIKit/UIKit.h>
#import "JSLTipsInfo.h"


@protocol JSLTipsLoadingProtocol <NSObject>

- (void)startAnimating;

@end

@protocol JSLTipsProgressProtocol <NSObject>
/**
 *  自定义的进度视图刷新进度方法
 *
 */
- (void)setProgress:(CGFloat)progress;
/**
 *  以下方法预留
 */
- (void)updateComplete;
- (BOOL)willAnimate;
- (void)animateCompletion:(void(^)(void))block;

@end

@interface JSLTipsView : UIView
/**
 *  对应的info
 */
@property (nonatomic, copy, readonly) JSLTipsInfo    *tipsInfo;
/**
 *  是否可见
 */
@property (nonatomic, assign, readonly) BOOL        visible;
/**
 *  是否可见
 */
@property (nonatomic, assign, readonly) BOOL        isProgress;
/**
 *  是否可见
 */
@property (nonatomic, assign, readonly) BOOL        reusable;
/**
 *  所持有的自定义视图，无为nil
 */
@property (nonatomic, strong, readonly) UIView      *customView;

/**
 *  实例化方法
 */
//CR： disappear意义不明确，建议改为disappearHandler，或者是hiddenCompletion
- (instancetype)initWithTips:(JSLTipsInfo *)tips;

/**
 *  更新布局
 *
 */
- (void)updateWithTips:(JSLTipsInfo *)tips;

/**
 *  显示方法
 *
 *  @param completeBlock 显示动画完成block，预留
 */
- (void)show:(void(^)(void))completeBlock;

/**
 *  隐藏方法
 *
 *  @param completeBlock 隐藏动画完成block，预留
 */
- (void)hide:(void(^)(void))completeBlock;

/**
 *  目前只支持更新tips位置
 *
 */
- (void)executeAnimation:(JSLTipsInfo *)tips completion:(dispatch_block_t)block;


- (UIView *)currentSuperview;

@end
