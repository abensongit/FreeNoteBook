
#import <Foundation/Foundation.h>
#import "JSLPlaceInfo.h"

@protocol JSLPlacePublishSheetDelegate <NSObject>

- (void)confirmWithPlaceInfo:(JSLPlaceInfo *)placeInfo;

@end

@interface JSLPlacePublishSheet : NSObject

@property (nonatomic, weak) id<JSLPlacePublishSheetDelegate> delegate;

- (void)show;

- (void)dismiss;

@end
