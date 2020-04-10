
#import <Foundation/Foundation.h>

@protocol JSLSettingActionSheetDelegate <NSObject>

- (void)takePhoto;
- (void)searchFromAlbum;

@end

@interface JSLSettingActionSheet : NSObject

@property (nonatomic, weak) id<JSLSettingActionSheetDelegate> delegate;

- (void)show;

@end
