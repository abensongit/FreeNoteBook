
#import <UIKit/UIKit.h>

@protocol GKImageCropControllerDelegate;
typedef void(^GKCancelAction)(void);

@interface GKImageCropViewController : UIViewController{
    UIImage *_croppedImage;
}

@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) CGSize cropSize; //size of the crop rect, default is 320x320
@property (nonatomic, assign) BOOL resizeableCropArea; 
@property (nonatomic, weak) id<GKImageCropControllerDelegate> delegate;

- (void)setActionCancel:(GKCancelAction)cancel;
@end


@protocol GKImageCropControllerDelegate <NSObject>
@required
- (void)imageCropController:(GKImageCropViewController *)imageCropController didFinishWithCroppedImage:(UIImage *)croppedImage;
@end
