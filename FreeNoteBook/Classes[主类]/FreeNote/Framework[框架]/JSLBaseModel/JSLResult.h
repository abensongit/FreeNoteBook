
#import <Foundation/Foundation.h>

@interface JSLResult<__covariant ObjectType> : NSObject

@property (nonatomic, strong) ObjectType    result;
@property (nonatomic, strong) NSError       *error;
@property (nonatomic, copy)   NSString      *message;

@end


typedef void (^JSLResultBlock)(JSLResult *result);

