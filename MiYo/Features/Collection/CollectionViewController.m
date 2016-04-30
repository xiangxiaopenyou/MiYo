//
//  CollectionViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CollectionViewController.h"
#import "HousingResourceCell.h"
#import "HousingModel.h"
#import "Util.h"
#import "PersonalModel.h"
#import <MJRefresh.h>
#import "IndexReulstModel.h"

@interface CollectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *collectionTableView;
@property (assign, nonatomic) NSInteger index;
@property (copy, nonatomic) NSMutableArray *collectionArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收藏";
    [_collectionTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _index = 0;
        [self fetchCollection];
    }]];
    [_collectionTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchCollection];
    }]];
    _collectionTableView.mj_footer.hidden = YES;
    _index = 0;
    [self fetchCollection];
    
    
}
- (void)fetchCollection {
    [PersonalModel fetchMyCollectionWith:_index handler:^(IndexReulstModel *object, NSString *msg) {
        [_collectionTableView.mj_header endRefreshing];
        [_collectionTableView.mj_footer endRefreshing];
        if (!msg) {
            if (_index == 0) {
                _collectionArray = [object.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_collectionArray mutableCopy];
                [tempArray addObjectsFromArray:object.result];
                _collectionArray = tempArray;
            }
            [_collectionTableView reloadData];
            BOOL haveMore = object.haveMore;
            if (haveMore) {
                _index = object.index + 1;
                _collectionTableView.mj_footer.hidden = NO;
            } else {
                [_collectionTableView.mj_footer endRefreshingWithNoMoreData];
                _collectionTableView.mj_footer.hidden = YES;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _collectionArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HousingSourceCell";
    HousingResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HousingResourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HousingModel *model = _collectionArray[indexPath.row];
    [cell setupDataWith:model];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
