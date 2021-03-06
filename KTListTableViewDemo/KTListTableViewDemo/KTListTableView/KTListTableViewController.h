//
//  KTListTableViewController.h
//  KTListTableViewDemo
//
//  Created by KT on 15/12/4.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KTListDataModel;

@protocol KTListTableDelegate <NSObject>
@optional
- (void) KTListTableDidSelectedData:(KTListDataModel *)selectModel;
@end

@interface KTListTableViewController : UITableViewController
@property (nonatomic, weak) id <KTListTableDelegate> delegate;
//初始化
- (instancetype)initWithData:(NSArray *)dataList;
@end
