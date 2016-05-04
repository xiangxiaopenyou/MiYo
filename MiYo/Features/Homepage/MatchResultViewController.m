//
//  MatchResultViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/3.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MatchResultViewController.h"
#import "MatchResultCell.h"
#import "UserModel.h"
#import <MJRefresh.h>
#import "MBProgressHUD+Add.h"
#import "InviteRequest.h"

@interface MatchResultViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSMutableArray *selectedIndexArray;

@end

@implementation MatchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"匹配结果";
    _mainTableView.tableFooterView = [UIView new];
    [_mainTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchMatchResult];
    }]];
    _userArray = [_indexModel.result mutableCopy];
    [_mainTableView reloadData];
    BOOL haveMore = _indexModel.haveMore;
    if (haveMore) {
        _index = _indexModel.index;
        _mainTableView.mj_footer.hidden = NO;
    } else {
        [_mainTableView.mj_footer endRefreshingWithNoMoreData];
        _mainTableView.mj_footer.hidden = YES;
    }
    _selectedIndexArray = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchMatchResult {
    [UserModel matchUsersWith:_housingModel.id sex:_sex index:_index handler:^(IndexReulstModel *object, NSString *msg) {
        if (!msg) {
            if (_index == 0) {
                _userArray = [_indexModel.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_userArray mutableCopy];
                [tempArray addObjectsFromArray:object.result];
                _userArray = tempArray;
            }
            [_mainTableView reloadData];
            BOOL haveMore = _indexModel.haveMore;
            if (haveMore) {
                _index = _indexModel.index;
                _mainTableView.mj_footer.hidden = NO;
            } else {
                [_mainTableView.mj_footer endRefreshingWithNoMoreData];
                _mainTableView.mj_footer.hidden = YES;
            }
        }
    }];
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MatchResultCell";
    MatchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MatchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setupContentWith:_userArray[indexPath.row]];
    if ([_selectedIndexArray containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_selectedIndexArray containsObject:indexPath]) {
        [_selectedIndexArray removeObject:indexPath];
    } else {
        [_selectedIndexArray addObject:indexPath];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)inviteClick:(id)sender {
    if (_selectedIndexArray.count == 0) {
        [MBProgressHUD showError:@"请先选择一个用户" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    NSMutableDictionary *dictionary = [@{@"userid" : userId,
                                         @"houseid" : _housingModel.id} mutableCopy];
    for (NSInteger i = 0; i < _selectedIndexArray.count; i ++) {
        NSIndexPath *indexPath = _selectedIndexArray[i];
        UserModel *user = _userArray[indexPath.row];
        NSString *invitedUserId = user.id;
        [dictionary setObject:invitedUserId forKey:[NSString stringWithFormat:@"userid%@", @(i + 1)]];
    }
    [[InviteRequest new] request:^BOOL(InviteRequest *request) {
        request.param = dictionary;
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            [MBProgressHUD showSuccess:@"邀请成功" toView:self.view];
        } else {
            [MBProgressHUD showError:@"邀请失败" toView:self.view];
        }
    }];
    
}

@end
