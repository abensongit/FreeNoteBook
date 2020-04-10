
#import <Foundation/Foundation.h>

@protocol JSLBaseDataProvider <NSObject>

//子类需要重写
@property (nonatomic, readonly) NSString  *name;
@property (nonatomic, readonly) NSInteger version;

@end


@interface JSLBaseDataProvider : NSObject<JSLBaseDataProvider>

@end
