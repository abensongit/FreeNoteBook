//
//  UITableView+Scroll.h
//  YHSCategories
//
//  Created by MASON on 2016/11/29.
//  Copyright © 2016年 MASON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Scroll)

- (void)scrollTableToTopAnimated:(BOOL)animated;

- (void)scrollTableToBottomAnimated:(BOOL)animated;

- (NSIndexPath *)firstIndexPath;

- (NSIndexPath *)lastIndexPath;

@end
