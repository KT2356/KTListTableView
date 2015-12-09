//
//  KTListTableViewController.m
//  KTListTableViewDemo
//
//  Created by KT on 15/12/4.
//  Copyright © 2015年 KT. All rights reserved.
//
  
#import "KTListTableViewController.h"
#import "KTListTableCell.h"
#import "KTWordIndex.h"
#import "KTSearchUpdateVC.h"

@interface KTListTableViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,KTSearchResultDelegate>
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *sortIndex;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) KTSearchUpdateVC *searResultVC;
@end

@implementation KTListTableViewController
#pragma mark - life cycle
- (instancetype)initWithData:(NSArray *)dataList {
    self = [[UIStoryboard storyboardWithName:@"KTListTableView" bundle:nil] instantiateInitialViewController];
    self.dataArray = dataList;
    self.dataDict = [[KTWordIndex sharedModel] analysisDataList:dataList];
    self.sortIndex = [self.dataDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isEqualToString:@"#"]) {
            return 1;
        }
        if ([obj2 isEqualToString:@"#"]) {
            return -1;
        }
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - private methods
- (KTListDataModel *)bindData:(NSIndexPath *)indexPath {
    KTListDataModel *model = [[KTListDataModel alloc] init];
    if (indexPath.section == 0) {
        NSArray *name  = @[@"订阅号",@"公众号"];
        NSArray *image = @[[UIImage imageNamed:@"a"],[UIImage imageNamed:@"b"]];
        model.userName = name[indexPath.row];
        model.userIcon = image[indexPath.row];
    } else {
        NSArray *data = [self.dataDict valueForKey:self.sortIndex[indexPath.section - 1]];
        model = data[indexPath.row];
    }
    return model;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortIndex.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        NSArray *data = [self.dataDict valueForKey:self.sortIndex[section - 1]];
        return data.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *backView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        indexLabel.backgroundColor = [UIColor clearColor];
        indexLabel.font = [UIFont systemFontOfSize:14];
        indexLabel.text = self.sortIndex[section - 1];
        [backView addSubview:indexLabel];
        return  backView;
    } else  {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KTListTableCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:@"KTListTableCell"];
    KTListDataModel *model = [self bindData:indexPath];
    cell.nameLabel.text    = model.userName;
    cell.image.image       = model.userIcon;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     KTListDataModel *model = [self bindData:indexPath];
    if ([self.delegate respondsToSelector:@selector(KTListTableDidSelectedData:)]) {
        [self.delegate KTListTableDidSelectedData:model];
    }
}

#pragma mark - KTSearchResultDelegate
- (void)KTSearchResultDidSelected:(KTListDataModel *)model {
    if ([self.delegate respondsToSelector:@selector(KTListTableDidSelectedData:)]) {
        [self.delegate KTListTableDidSelectedData:model];
    }
}

#pragma mark - TableIndex
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortIndex;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate  = [NSPredicate predicateWithFormat:@"userName CONTAINS %@", searchString];
    NSArray *result        = [self.dataArray filteredArrayUsingPredicate:preicate];
    self.searResultVC.searchResult = result.count > 0 ? result : nil;
    self.searResultVC.tableView.tableFooterView.hidden = result.count > 0 ? YES : NO;
    [self.searResultVC.tableView reloadData];
}

#pragma mark - setter/getter
- (NSDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [[NSDictionary alloc] init];
    }
    return _dataDict;
}

- (NSArray *)sortIndex {
    if (!_sortIndex) {
        _sortIndex = [[NSArray alloc] init];
    }
    return _sortIndex;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searResultVC];
        _searchController.searchResultsUpdater                 = self;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.delegate                             = self;
        _searchController.searchBar.delegate                   = self;
    }
    return _searchController;
}
- (KTSearchUpdateVC *)searResultVC {
    if (!_searResultVC) {
        _searResultVC          = [[KTSearchUpdateVC alloc] init];
        _searResultVC.delegate = self;
    }
    return _searResultVC;
}
@end
