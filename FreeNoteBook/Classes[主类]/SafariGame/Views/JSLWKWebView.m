
#import "JSLWKWebView.h"

@implementation JSLWKWebView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hitTestEventBlock) {
        self.hitTestEventBlock();
    }
    return [super hitTest:point withEvent:event];
}

@end
