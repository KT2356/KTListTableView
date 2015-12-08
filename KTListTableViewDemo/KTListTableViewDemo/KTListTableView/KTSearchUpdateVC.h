//
//  KTSearchUpdateVC.h
//  KTListTableViewDemo
//
//  Created by KT on 15/12/8.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTListDataModel.h"
@protocol KTSearchResultDelegate <NSObject>
- (void)KTSearchResultDidSelected:(KTListDataModel *)model ;
@end

@interface KTSearchUpdateVC : UITableViewController
@property (nonatomic, weak) id <KTSearchResultDelegate> delegate;
@property (nonatomic, strong) NSArray *searchResult;
@end
