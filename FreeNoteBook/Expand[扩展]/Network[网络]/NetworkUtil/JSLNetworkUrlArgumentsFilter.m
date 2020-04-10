
#import "JSLNetworkUrlArgumentsFilter.h"
#import "NSString+JSLNetworkUrlUtil.h"

@interface JSLNetworkUrlArgumentsFilter ()

@property NSDictionary *arguments;

@end


@implementation JSLNetworkUrlArgumentsFilter

+ (instancetype)filterWithArguments:(NSDictionary<NSString *, NSString *> *)arguments
{
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary<NSString *, NSString *> *)arguments
{
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request
{
    return [originUrl networkUrlStringByAppendURLParameters:_arguments];
}


@end
