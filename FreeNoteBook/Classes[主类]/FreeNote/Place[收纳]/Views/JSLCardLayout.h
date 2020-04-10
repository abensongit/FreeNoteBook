
#import <UIKit/UIKit.h>

@protocol JSLCardLayoutDelegate <NSObject>

- (void)updateBlur:(CGFloat)blur ForRow:(NSInteger)row;

@end

@interface JSLCardLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat         offsetY;
@property (nonatomic, assign) CGFloat         contentSizeHeight;
@property (nonatomic, strong) NSMutableArray  *blurList;
@property (nonatomic, weak)   id<JSLCardLayoutDelegate> delegate;

- (instancetype)initWithOffsetY:(CGFloat)offsetY;

@end
