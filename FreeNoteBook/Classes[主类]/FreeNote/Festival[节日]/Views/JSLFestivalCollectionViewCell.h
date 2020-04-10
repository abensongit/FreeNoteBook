
#import <UIKit/UIKit.h>
#import "JSLFestivalInfo.h"

@protocol JSLFestivalCollectionViewCellDelegate <NSObject>

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JSLFestivalCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<JSLFestivalCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)updateCellWithDayInfo:(JSLFestivalInfo *)dayInfo;

@end
