//
//  KTListTableCell.m
//  KTListTableViewDemo
//
//  Created by KT on 15/12/7.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "KTListTableCell.h"

@implementation KTListTableCell

/**
 *  @author KT, 2015-12-09 09:38:41
 *
 *  隐藏tableview section 分割线，该线在刷新table时有时会出现
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"] && subview.frame.origin.x == 0) {
            subview.hidden = YES;
        }
    }
}


@end
