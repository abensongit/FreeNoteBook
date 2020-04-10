
#import "JSLAssistiveTouchButton.h"

typedef void(^BlockItemButtonHandle)(NSUInteger index);

@interface JSLAssistiveTouchButton ()
@property (nonatomic, copy) BlockItemButtonHandle itemButtonBlock;
@end

@implementation JSLAssistiveTouchButton

- (instancetype)initWithCapacity:(NSUInteger)itemsNum
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.subItems = [self itemsArrFromGetItemsNum:itemsNum];
    return self;
}

+ (instancetype)spreadButtonWithCapacity:(NSUInteger)itemsNum
{
    return [[self alloc] initWithCapacity:itemsNum];
}

- (NSArray *)itemsArrFromGetItemsNum:(NSUInteger)itemsNum
{
    NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:itemsNum];
    for (int idx = 0; idx < itemsNum; idx ++) {
        UIButton *item = [[UIButton alloc] init];
        [item setTag:idx];
        [item addTarget:self action:@selector(didClickButtonAtItem:) forControlEvents:UIControlEventTouchUpInside];
        [itemsArray addObject:item];
    }
    return [itemsArray copy];
}

- (void)spreadButtonDidClickItemAtIndex:(void (^)(NSUInteger index))itemButtonBlock
{
    if (itemButtonBlock) {
        self.itemButtonBlock = itemButtonBlock;
    }
}

#pragma mark -
#pragma mark -- 按钮点击方法

- (void)didClickButtonAtItem:(UIButton *)item
{
    ![self.delegate respondsToSelector:@selector(touchButton:didSelectedAtIndex:withSelectedButton:)] ?: [self.delegate touchButton:self didSelectedAtIndex:item.tag withSelectedButton:item];
    !self.itemButtonBlock ?: self.itemButtonBlock(item.tag);
    [self shrinkWithHandle:^{}];
}

/**
 在浏览器控件中，解决按钮超出部分无法被关闭的问题
 */
- (void)hitTestWithEventToShrinkCloseHandle
{
    [self shrinkWithHandle:^{}];
}

/**
 重写点击方法，解决按钮超出部分无法被电击的问题
 */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isSpreading) {
        if (CGRectContainsPoint(self.bounds, point)) {
            return YES;
        }
        for (UIButton *btn in self.subItems) {
            if (CGRectContainsPoint(btn.frame, point)) {
                return YES;
            }
        }
        return NO;
    } else {
        return [super pointInside:point withEvent:event];
    }
}


#pragma mark -
#pragma mark -- set

- (void)setImages:(NSArray *)images
{
    _images = images;
    
    self.subItems = [self itemsArrFromGetItemsNum:images.count];
    
    for (int i = 0; i < images.count; i++) {
        UIButton *button = (UIButton *)self.subItems[i];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
    }
}

- (void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    
    [self.spreadButton setImage:normalImage forState:UIControlStateNormal];
}

- (void)setSelectImage:(UIImage *)selectImage
{
    _selectImage = selectImage;
    
    [self.spreadButton setImage:selectImage forState:UIControlStateSelected];
}

@end

