//
//  UIImage+ChangeColor.h
//  FINDIOSPROJECT
//
//  Created by MASON on 2018/7/26.
//  Copyright © 2018年 MASON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ChangeColor)

- (UIImage *)imageWithTintColor:(UIColor*)tintColor;

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

@end
