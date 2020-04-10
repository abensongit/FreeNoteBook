
#import <UIKit/UIKit.h>
#import "JSLPlaceInfo.h"

@protocol JSLCardCollectionViewCellDelegate <NSObject>

- (void)deleteIndexPath:(NSIndexPath *)indexPath;

@end

@interface JSLCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<JSLCardCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)updateCellWithPlaceInfo:(JSLPlaceInfo *)placeInfo bgColor:(UIColor *)bgColor;

- (void)setBlur:(CGFloat)ratio;//设置毛玻璃效果

@end
