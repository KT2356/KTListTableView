//
//  KTSearchUpdateVC.m
//  KTListTableViewDemo
//
//  Created by KT on 15/12/8.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "KTSearchUpdateVC.h"
#import "KTListTableCell.h"
#import "KTListDataModel.h"
@implementation KTSearchUpdateVC
#pragma mark - life cycle
- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"KTListTableView" bundle:nil] instantiateViewControllerWithIdentifier:@"KTSearchUpdateVC"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTListTableCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:@"KTListTableCell"forIndexPath:indexPath];
    if (self.searchResult.count > 0) {
        KTListDataModel *model = self.searchResult[indexPath.row];
        cell.nameLabel.text    = model.userName;
        cell.image.image       = model.userIcon;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KTListDataModel *model = self.searchResult[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(KTSearchResultDidSelected:)]) {
        [self.delegate KTSearchResultDidSelected:model];
    }
}

#pragma mark - setter/getter
- (NSArray *)searchResult {
    if (!_searchResult) {
        _searchResult = [[NSArray alloc] init];
    }
    return _searchResult;
}
@end
