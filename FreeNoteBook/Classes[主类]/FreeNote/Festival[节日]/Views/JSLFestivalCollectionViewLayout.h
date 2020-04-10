
#import <UIKit/UIKit.h>

@class JSLFestivalCollectionViewLayout;

@protocol JSLFestivalCollectionViewLayoutDelegate <NSObject>

@required

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(JSLFestivalCollectionViewLayout *)layout
  heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface JSLFestivalCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) CGFloat    interItemSpacing;
@property (nonatomic, weak)   id<JSLFestivalCollectionViewLayoutDelegate> delegate;

@end
