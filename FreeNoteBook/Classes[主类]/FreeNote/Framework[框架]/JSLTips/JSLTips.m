
#import <objc/runtime.h>

#import "JSLTips.h"
#import "JSLProgressLoopView.h"

@interface JSLTipsInfo (Complete)
@property (nonatomic, copy) void(^hiddenCompletion)(void);
@end


NSString *const                 kEMManualTipsView;


@interface JSLTips()

@property (nonatomic, strong) JSLTipsView        *autoTipsView;
@property (nonatomic, strong) JSLTipsView        *manualTipsView;
@property (nonatomic, strong) UIView            *background;
@property (nonatomic, strong) NSMutableArray    *tipsQueue;
@property (nonatomic, assign) CGRect            keyboardFrame;

@end

@implementation JSLTips

#pragma mark - Life cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        _tipsQueue = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardFrameChange:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Public

+ (instancetype)sharedTips
{
    static JSLTips *_st = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _st = [[JSLTips alloc] init];
    });
    return _st;
}


+ (void)showTips:(JSLTipsInfo *)tips complete:(void(^)(void))block
{
    //CR: 建议不要将复杂的逻辑封装到类方法中，而是封装到成员方法中
    if ([NSThread isMainThread]) {
        [[self sharedTips] showTips:tips hiddenCompletion:block];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self sharedTips] showTips:tips hiddenCompletion:block];
        });
    }
}


//+ (void)showManualTips:(JSLTipsInfo *)tips addTo:(id)controller
//{
//    [[self sharedTips] showManualTips:tips addTo:controller];
//}


+ (void)hideTips
{
    JSLTips *shared = [JSLTips sharedTips];
    JSLTipsView *manualView = shared.manualTipsView;
    shared.manualTipsView = nil;
    if ([NSThread isMainThread]) {
        [manualView hide:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [manualView hide:nil];
        });
    }
}

#pragma mark Private

- (void)showTips:(JSLTipsInfo *)tips hiddenCompletion:(void(^)(void))block
{
    BOOL isAuto = tips.duration > 0;
    
    if (isAuto) { //auto hide tips
        JSLTipsView *curAutoTipsView = [self autoTipsView];
        BOOL shouldQueue = (self.tipsQueue.count > 0 || curAutoTipsView.visible) &&
                            tips.isSuperViewVisible;
        tips.hiddenCompletion = block;
        if (shouldQueue) {
            [self enqueueAutoTips:tips];
        } else {
            [self displayAutoTips:tips];
        }
    } else { //manual hide tips
        JSLTipsInfo *autoTips    = self.autoTipsView.tipsInfo;
        BOOL existAutoTips      = self.autoTipsView.visible;
        BOOL sameSuperview      = autoTips.superView == tips.superView;
        
        BOOL isVisible = self.manualTipsView.visible;
        if (isVisible) {
            [self.manualTipsView updateWithTips:tips];
        } else {
            [self.manualTipsView hide:nil];
            JSLTipsView *usableView = [self getUsableTipsViewWithTips:tips];
            self.manualTipsView = usableView;
            [usableView show:nil];
        }
        
        if (existAutoTips && sameSuperview &&
            autoTips.position == JSLTipsPositionCenter) { // 已存在auto tips，auto tips 动态移至底部
            CGFloat offset = self.autoTipsView.bounds.size.height + self.manualTipsView.bounds.size.height;
            autoTips.offset     = CGPointMake(0, offset / 2 + 8);
            [self.autoTipsView executeAnimation:autoTips completion:nil];
        }
    }
}


//- (void)showManualTips:(JSLTipsInfo *)tips addTo:(id)controller
//{
//    if (controller == nil) {
//        return;
//    }
//    
//    
//    BOOL existAutoTips = self.autoTipsView.visible;
//    if (existAutoTips) { // 已存在auto tips，auto tips 动态移至底部
//        JSLTipsInfo *autoTips    = self.autoTipsView.tipsInfo;
//        autoTips.position       = JSLTipsPositionBottom;
//        [self.autoTipsView executeAnimation:autoTips completion:nil];
//    }
//    
//    JSLTipsView *manualTipsView = objc_getAssociatedObject(controller, &kEMManualTipsView);
//    BOOL existManualTips = manualTipsView.visible;
//    if (existManualTips) {
//        [manualTipsView hide:nil];
//    }
//    
//    JSLTipsView *usableView = [self getUsableTipsViewWithTips:tips];
//    objc_setAssociatedObject(controller, &kEMManualTipsView, usableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [usableView show:nil];
//}


//CR：方法太长了，可参看《重构》的方法进行方法封装的提炼；
//    由于存在递归调用来执行队列，所以建议能将递归调用封装得更为明确。
- (void)displayAutoTips:(JSLTipsInfo *)tips
{
    
    __weak typeof(self) weakSelf = self;
    
    void(^originalBlock)(void) = tips.hiddenCompletion;
    
    void(^completionBlock)(void) = ^(void) {
        
        if (originalBlock) {
            originalBlock();
        }
        
        JSLTipsInfo *next = [weakSelf dequeueAutoTips];
        if (next) {
            [weakSelf displayAutoTips:next];
        } else {
            weakSelf.autoTipsView = nil;
        }
    };
    
    tips.hiddenCompletion = completionBlock;
    
    BOOL existManualTips = self.manualTipsView.visible;
    if (existManualTips) {
        tips.position = JSLTipsPositionBottom;
    }
    
    JSLTipsView *usableTipsView = [self getUsableTipsViewWithTips:tips];
    
    self.autoTipsView = usableTipsView;
    
    [usableTipsView show:nil];
}


- (JSLTipsView *)getUsableTipsViewWithTips:(JSLTipsInfo *)tips
{
    JSLTipsView *tipsView = nil;
    
    BOOL existManualTips = self.manualTipsView.visible;
    
    if (self.autoTipsView.reusable) {
        tipsView = self.autoTipsView;
    }
    else if (self.manualTipsView.reusable) {
        tipsView = self.manualTipsView;
    }
    
    BOOL isAuto = tips.duration > 0;
    
    if (isAuto && existManualTips) {
        tips.position = JSLTipsPositionBottom;
    }
    
    if (!tipsView) {
        tipsView = [[JSLTipsView alloc] initWithTips:tips];
    } else {
        [tipsView updateWithTips:tips];
    }
    
    return tipsView;
}


#pragma mark - Queue

- (void)enqueueAutoTips:(JSLTipsInfo *)tips
{
    if ([self.autoTipsView.tipsInfo isEqualTo:tips]) {
        return;
    }
    if (self.tipsQueue.count > 1) {
        return;     //  控制下栈数
    }
    [self.tipsQueue addObject:tips];
}


- (JSLTipsInfo *)dequeueAutoTips
{
    JSLTipsInfo *tips = self.tipsQueue.firstObject;
    if (tips && !tips.isSuperViewVisible) {// 如果父视图都已经释放了或者不可见了，直接出栈
        [self.tipsQueue removeObject:tips];
        return [self dequeueAutoTips];
    }
    if (tips) {
        [self.tipsQueue removeObject:tips];
    }
    return tips;
}


#pragma mark - Helper


- (void)handleKeyboardFrameChange:(NSNotification *)notification
{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}


- (BOOL)isKeyboardShow
{
    return  (self.keyboardFrame.origin.y < [UIScreen mainScreen].bounds.size.height && self.keyboardFrame.size.width == [UIScreen mainScreen].bounds.size.width) ||
    (self.keyboardFrame.origin.y < [UIScreen mainScreen].bounds.size.width && self.keyboardFrame.size.width == [UIScreen mainScreen].bounds.size.height);
}







#pragma mark - Public convenient methods


+ (void)show:(NSString *)text
{
    JSLTipsInfo *tips = [JSLTipsInfo defaultAutoInfo];
    tips.title = text;
    [JSLTips showTips:tips complete:nil];
}


+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
{
    [self showMessage:message
                image:nil
               inView:container
             duration:duration
          interaction:YES
             complete:nil];
}




+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
{
    [self showMessage:message
                image:nil
               inView:container
             duration:duration
               offset:CGPointZero
          interaction:enable
             complete:nil];
}



+ (void)showMessage:(NSString *)message
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
           complete:(void (^)(void))block
{
    [self showMessage:message
                image:nil
               inView:container
             duration:duration
               offset:CGPointZero
          interaction:enable
             complete:block];
}


+ (void)showMessage:(NSString *)message
              image:(UIImage *)image
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
        interaction:(BOOL)enable
           complete:(void (^)(void))block
{
    [self showMessage:message
                image:image
               inView:container
             duration:duration
               offset:CGPointZero
          interaction:enable
             complete:block];
}


+ (void)showTitle:(NSString *)title
          message:(NSString *)message
           inView:(UIView *)container
         duration:(NSTimeInterval)duration
         complete:(void (^)(void))block
{
    JSLTipsInfo *tips = [JSLTipsInfo defaultAutoInfo];
    tips.title      = title;
    tips.message    = message;
    tips.duration   = duration;
    tips.superView  = container;
    [JSLTips showTips:tips complete:block];
}


+ (void)showMessage:(NSString *)message
              image:(UIImage *)image
             inView:(UIView *)container
           duration:(NSTimeInterval)duration
             offset:(CGPoint)offset
        interaction:(BOOL)enable
           complete:(void(^)(void))block
{
    JSLTipsInfo *tips = [JSLTipsInfo defaultAutoInfo];
    tips.message    = message;
    tips.duration   = duration;
    tips.superView  = container;
    tips.offset     = offset;
    tips.userInteractionEnabled = enable;
    if (image) {
        tips.customView = [[UIImageView alloc] initWithImage:image];
    }
    [JSLTips showTips:tips complete:block];
}

+ (void)showLoading:(UIView *)loading
            message:(NSString *)message
             inView:(UIView *)container
        interaction:(BOOL)enable
{
    [self showLoading:loading
              message:message
               inView:container
               offset:CGPointZero
          interaction:enable];
}


+ (void)showLoading:(UIView *)loading
            message:(NSString *)message
             inView:(UIView *)container
             offset:(CGPoint)offset
        interaction:(BOOL)enable
{
    JSLTipsInfo *tips = [JSLTipsInfo defaultManualInfo];
    if (message == nil) {
        tips.backgroundColor = [UIColor clearColor];
    }
    tips.offset = offset;
    tips.message = message;
    tips.superView = container;
    tips.userInteractionEnabled = enable;
    tips.customView = loading;
    [JSLTips showTips:tips complete:nil];
}


+ (void)showProgress:(CGFloat)progress
             message:(NSString *)message
              inView:(UIView *)container
         interaction:(BOOL)enable
{
    [self showProgress:progress
               message:message
                inView:container
                offset:CGPointZero
           interaction:enable];
}


+ (void)showProgress:(CGFloat)progress
             message:(NSString *)message
              inView:(UIView *)container
              offset:(CGPoint)offset
         interaction:(BOOL)enable
{
    JSLTipsView *manualTipsView = [JSLTips sharedTips].manualTipsView;
    if (manualTipsView.visible && !manualTipsView.isProgress) {
        [JSLTips hideTips];
    }
    if (!manualTipsView.visible) {
        JSLTipsInfo *tips = [JSLTipsInfo defaultManualInfo];
        tips.message = message;
        tips.offset = offset;
        tips.superView = container;
        JSLProgressLoopView *progressView = [JSLProgressLoopView defaultProgressLoopView];
        progressView.progress = progress;
        tips.customView = progressView;
        tips.userInteractionEnabled = enable;
        [JSLTips showTips:tips complete:nil];
    } else {
        UIView<JSLTipsProgressProtocol> *progressView = (UIView<JSLTipsProgressProtocol> *)manualTipsView.customView;
        if ([progressView respondsToSelector:@selector(setProgress:)]) {
            [progressView setProgress:progress];
        }
        
        if (![manualTipsView.tipsInfo.message isEqualToString:message]) {
            JSLTipsInfo *tips = manualTipsView.tipsInfo;
            tips.message = message;
            [manualTipsView updateWithTips:tips];
        }
    }
}


+ (void)showProgress:(CGFloat)progress message:(NSString *)message
{
    JSLTipsView *manualTipsView = [JSLTips sharedTips].manualTipsView;
    if (manualTipsView.visible && !manualTipsView.isProgress) {
        [JSLTips hideTips];
    }
    
    if (!manualTipsView.visible) {
        JSLTipsInfo *tips = [JSLTipsInfo defaultManualInfo];
        tips.message = message;
        tips.customView = [JSLProgressLoopView defaultProgressLoopView];
        [JSLTips showTips:tips complete:nil];
    } else {
        UIView<JSLTipsProgressProtocol> *progressView = (UIView<JSLTipsProgressProtocol> *)manualTipsView.customView;
        if ([progressView respondsToSelector:@selector(setProgress:)]) {
            [progressView setProgress:progress];
        }
        
        if (![manualTipsView.tipsInfo.message isEqualToString:message]) {
            JSLTipsInfo *tips = manualTipsView.tipsInfo;
            tips.message = message;
            [manualTipsView updateWithTips:tips];
        }
    }
}



@end
