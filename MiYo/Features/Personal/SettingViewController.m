//
//  SettingViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "SettingViewController.h"
#import "XLBlockAlertView.h"
#import "CommonsDefines.h"
#import "FindPasswordViewController.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    if (_logoutButton.layer.cornerRadius != 2.0) {
        _logoutButton.layer.masksToBounds = YES;
        _logoutButton.layer.cornerRadius = 2.0;
    }
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_setting0%@", @(indexPath.row + 1)]];
    cell.textLabel.text = indexPath.row == 0 ? @"用户反馈" : @"修改密码";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIViewController *feedbackViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil  ] instantiateViewControllerWithIdentifier:@"FeedbackView"];
        [self.navigationController pushViewController:feedbackViewController animated:YES];
    } else {
        FindPasswordViewController *viewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"FindPasswordView"];
        viewController.viewTitle = @"修改密码";
        [self.navigationController pushViewController:viewController animated:YES];
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
- (IBAction)logoutClick:(id)sender {
    [[[XLBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗？" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (buttonIndex == 1) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERID];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:NICKNAME];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:PORTRAIT];
                [self.navigationController popViewControllerAnimated:YES];
                [self performSelector:@selector(postInformation) withObject:nil afterDelay:0.5];
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}
- (void)postInformation {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutSuccess" object:nil];
}

@end
