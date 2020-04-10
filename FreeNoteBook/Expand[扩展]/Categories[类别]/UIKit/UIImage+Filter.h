//
//  UIImage+Filter.h
//  YHSCategories
//
//  Created by MASON on 2016/11/29.
//  Copyright © 2016年 MASON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filter)

- (UIImage *)filterGlaussianBlurWithRadius:(CGFloat)radius;

@end
