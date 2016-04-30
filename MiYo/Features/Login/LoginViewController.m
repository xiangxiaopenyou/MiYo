//
//  LoginViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginViewController.h"
#import "Util.h"
#import "XLNoticeHelper.h"
#import "LoginModel.h"
#import "CommonsDefines.h"
#import <MBProgressHUD.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController.navigationBar setBarTintColor:[Util turnToRGBColor:@"12c1e8"]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes: @{
//                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f]
//                                                            }];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (IBAction)loginClick:(id)sender {
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    if (![Util validatePhone:_usernameTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请输入正确的手机号"];
        return;
    }
    if ([Util isEmpty:_passwordTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请输入密码"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"正在登录...";
    [LoginModel loginWith:_usernameTextField.text password:_passwordTextField.text handler:^(id object, NSString *msg) {
        [hud setHidden:YES];
        if (msg) {
            [XLNoticeHelper showNoticeAtViewController:self message:@"登录失败"];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFail" object:nil];
        } else {
            NSLog(@"成功");
            [[NSUserDefaults standardUserDefaults] setValue:object[@"userid"] forKey:USERID];
            [[NSUserDefaults standardUserDefaults] setValue:object[@"nickname"] forKey:NICKNAME];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@", object[@"headphoto"]] forKey:PORTRAIT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self performSelector:@selector(turnToView) withObject:nil afterDelay:0.1];
        }
    }];
}
- (void)turnToView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewView" object:nil];
}
- (IBAction)forgetPasswordClick:(id)sender {
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
