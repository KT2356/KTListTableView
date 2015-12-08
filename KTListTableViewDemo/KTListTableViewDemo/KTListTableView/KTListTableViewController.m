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


@interface KTListTableViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *sortIndex;
@end

@implementation KTListTableViewController

- (instancetype)initWithData:(NSArray *)dataList {
    self = [super init];
    if (self) {
        self = [[UIStoryboard storyboardWithName:@"KTListTableView" bundle:nil] instantiateInitialViewController];
        self.automaticallyAdjustsScrollViewInsets = NO;
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
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
}

- (void)setupSearchBar {
    self.searchVC.placeholder = @"搜索";
    self.searchVC.delegate    = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
}


#pragma mark - Table view data source
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
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        indexLabel.backgroundColor = [UIColor clearColor];
        indexLabel.font = [UIFont boldSystemFontOfSize:14];
        indexLabel.text = self.sortIndex[section - 1];
        [backView addSubview:indexLabel];
        return  backView;
    } else  {
        return nil;
    }
}
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
    [self.delegate KTListTableDidSelectedData:model];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortIndex;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchVC resignFirstResponder];
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
@end
