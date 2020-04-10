
#import <UIKit/UIKit.h>

@interface JSLCardSelectedLayout : UICollectionViewLayout

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath
                          offsetY:(CGFloat)offsetY
                ContentSizeHeight:(CGFloat)sizeHeight;

@property (nonatomic, assign) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) CGFloat     contentOffsetY;
@property (nonatomic, assign) CGFloat     contentSizeHeight;

@end
