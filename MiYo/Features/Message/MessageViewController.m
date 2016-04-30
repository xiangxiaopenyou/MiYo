//
//  MessageViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MessageViewController.h"
#import "Util.h"
#import "SystemMessageCell.h"
#import "MessageModel.h"
#import "IndexReulstModel.h"
#import <MJRefresh.h>
#import "MessageDetailViewController.h"

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSMutableArray *messageArray;
@property (assign, nonatomic) NSInteger limitIndex;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBarTintColor:[Util turnToRGBColor:@"12c1e8"]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes: @{
//                                                                       NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                       NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]
//                                                                       }];
    self.navigationItem.title = @"消息";
    _messageTableView.tableFooterView = [UIView new];
    [_messageTableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _limitIndex = 0;
        [self fetchMessageList];
    }]];
    [_messageTableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self fetchMessageList];
    }]];
    _messageTableView.mj_footer.hidden = YES;
//    _messageArray = [NSMutableArray array];
//    for (NSInteger i = 0; i < 5; i ++) {
//        MessageModel *model = [MessageModel new];
//        model.id = [NSString stringWithFormat:@"%@", @(i)];
//        model.type = i % 2 == 1 ? @(1) : @(2);
//        model.state = @(0);
//        model.time = @"2016-4-24 16:27:00";
//        model.nickname = [NSString stringWithFormat:@"项小盆友%@", @(i)];
//        [_messageArray addObject:model];
//        
//    }
    _limitIndex = 0;
    
    
    [self fetchMessageList];
}
- (void)fetchMessageList {
    [MessageModel fetchMessageListWith:_limitIndex handler:^(IndexReulstModel *object, NSString *msg) {
        [_messageTableView.mj_header endRefreshing];
        [_messageTableView.mj_footer endRefreshing];
        if (!msg) {
            if (_limitIndex == 0) {
                _messageArray = [object.result mutableCopy];
            } else {
                NSMutableArray *tempArray = [_messageArray mutableCopy];
                [tempArray addObjectsFromArray:object.result];
                _messageArray = tempArray;
            }
            [_messageTableView reloadData];
            BOOL haveMore = object.haveMore;
            if (haveMore) {
                _limitIndex = object.index + 1;
                _messageTableView.mj_footer.hidden = NO;
            } else {
                [_messageTableView.mj_footer endRefreshingWithNoMoreData];
                _messageTableView.mj_footer.hidden = YES;
            }
        }
    }];
}
- (void)deleteMessage:(NSString *)messageId {
    [MessageModel deleteMessageWith:messageId handler:^(id object, NSString *msg) {
        if (!msg) {
            NSLog(@"删除成功");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SystemMessageCell";
    SystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MessageModel *tempModel = _messageArray[indexPath.row];
    if ([tempModel.type integerValue] == 1) {
        cell.textLabel.text = @"合租消息";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@希望能跟你合租，及时联系噢~", tempModel.nickname];
        cell.imageView.image = [UIImage imageNamed:@"icon_hezu"];
    } else {
        cell.textLabel.text = @"系统消息";
        cell.detailTextLabel.text = @"您有一条来自系统的消息";
        cell.imageView.image = [UIImage imageNamed:@"icon_message"];
    }
    [cell setupContentWithModel:tempModel];
    
    cell.backgroundColor = kRGBColor(250, 250, 250, 1.0);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageModel *tempModel = _messageArray[indexPath.row];
    MessageDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageDetailView"];
    viewController.model = tempModel;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageModel *tempModel = [_messageArray objectAtIndex:indexPath.row];
        [self deleteMessage:tempModel.id];
        [_messageArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
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
