//
//  KTListTableViewController.h
//  KTListTableViewDemo
//
//  Created by KT on 15/12/4.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTListDataModel.h"

@protocol KTListTableDelegate <NSObject>
@optional
- (void) KTListTableDidSelectedData:(KTListDataModel *)selectModel;
@end

@interface KTListTableViewController : UITableViewController
@property (nonatomic, weak) id <KTListTableDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchVC;


- (instancetype)initWithData:(NSArray *)dataList;
@end
