//
//  ViewController.m
//  KTListTableViewDemo
//
//  Created by KT on 15/12/4.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "ViewController.h"
#import "KTListTableViewController.h"
#import "KTListDataModel.h"

@interface ViewController ()<KTListTableDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *name = @[@"订单",@"6方",@"大的",@"后天",@"v 吧",@"看 ",@"个人",@"关于",@"搜索",@"不发",@"变化",@"9哦"];
    NSArray *image = @[@"a",@"c",@"b",@"a",@"a",@"c",@"b",@"b",@"c",@"a",@"a",@"b"];
    NSMutableArray *dataList = [@[] mutableCopy];
    
    for (int i = 0; i < name.count; i ++) {
        KTListDataModel *model = [[KTListDataModel alloc] init];
        model.userName = name[i];
        model.userIcon = [UIImage imageNamed:image[i]];
        [dataList addObject:model];
    }

    KTListTableViewController *KTview = [[KTListTableViewController alloc] initWithData:dataList];
    KTview.delegate = self;
    [self.navigationController pushViewController:KTview animated:YES];
    
    
    
}

- (void)KTListTableDidSelectedData:(KTListDataModel *)selectModel {
    NSLog(@"%@",selectModel.userName);
}


@end
