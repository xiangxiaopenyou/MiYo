//
//  MyHousingViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MyHousingViewController.h"
#import "MyHousingCell.h"
#import "PersonalModel.h"
#import <MJRefresh.h>
#import "IndexReulstModel.h"
#import "HousingModel.h"
#import "HousingDetailViewController.h"

@interface MyHousingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *housingArray;

@end

@implementation MyHousingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的发布";
    _index = 0;
    [_mainTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _index = 0;
        [self fetchMyHousing];
        
    }]];
    [_mainTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchMyHousing];
    }]];
    _mainTableView.mj_footer.hidden = YES;
    [self fetchMyHousing];
    
}
- (void)fetchMyHousing {
    [PersonalModel fetchMyHousingWith:_index handler:^(IndexReulstModel *object, NSString *msg) {
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
        if (!msg) {
            if (_index == 0) {
                _housingArray = [object.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_housingArray mutableCopy];
                [tempArray addObjectsFromArray:object.result];
                _housingArray = tempArray;
            }
            [_mainTableView reloadData];
            BOOL haveMore = object.haveMore;
            if (haveMore) {
                _index = object.index + 1;
                _mainTableView.mj_footer.hidden = NO;
            } else {
                [_mainTableView.mj_footer endRefreshingWithNoMoreData];
                _mainTableView.mj_footer.hidden = YES;
            }
        }
    }];
}
- (void)housingDelete:(NSString *)housingId {
    [HousingModel deleteHousingWith:housingId handler:^(id object, NSString *msg) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _housingArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyHousingCell";
    MyHousingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MyHousingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setupContentWith:_housingArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HousingModel *tempModel = _housingArray[indexPath.row];
    HousingDetailViewController *detailView = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingDetailView"];
    detailView.simpleModel = tempModel;
    detailView.housingId = tempModel.id;
    [self.navigationController pushViewController:detailView animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HousingModel *tempModel = _housingArray[indexPath.row];
        [self housingDelete:tempModel.id];
        [_housingArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
