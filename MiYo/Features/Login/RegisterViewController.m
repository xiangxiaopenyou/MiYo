//
//  RegisterViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/18.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "RegisterViewController.h"
#import "GetCodeRequest.h"
#import "Util.h"
#import "XLNoticeHelper.h"
#import "LoginModel.h"
#import "CommonsDefines.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (copy, nonatomic) NSString *receivedCode;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _getCodeButton.layer.masksToBounds = YES;
    _getCodeButton.layer.cornerRadius = 5.0;
    _getCodeButton.layer.borderWidth = 0.5;
    _getCodeButton.layer.borderColor = [Util turnToRGBColor:@"C9C9C9"].CGColor;
    
    _registerButton.layer.masksToBounds = YES;
    _registerButton.layer.cornerRadius = 2.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)getCodeClick:(id)sender {
    if (![Util validatePhone:_phoneNumTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请先输入正确的手机号"];
        return;
    }
    [[GetCodeRequest new] request:^BOOL(GetCodeRequest *request) {
        request.phoneNumber = _phoneNumTextField.text;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            [XLNoticeHelper showNoticeAtViewController:self message:@"发送验证码失败"];
        } else {
            NSLog(@"发送验证码成功");
            _receivedCode = object[@"vcode"];
            NSLog(@"%@", _receivedCode);
        }
    }];
}
- (IBAction)registerClick:(id)sender {
    if (![Util validatePhone:_phoneNumTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请先输入正确的手机号"];
        return;
    }
    if (!_receivedCode) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请先获取验证码"];
        return;
    }
    if ([Util isEmpty:_codeTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请先输入收到的验证码"];
        return;
    }
    if (![_codeTextField.text isEqual:_receivedCode]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"验证码错误"];
        return;
    }
    if ([Util isEmpty:_nicknameTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请输入你的昵称"];
        return;
    }
    if ([Util isEmpty:_passwordTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请输入你的用户密码"];
        return;
    }
    [LoginModel registerWith:_phoneNumTextField.text nickname:_nicknameTextField.text password:_passwordTextField.text handler:^(id object, NSString *msg) {
        if (msg) {
            [XLNoticeHelper showNoticeAtViewController:self message:msg];
        } else {
            NSLog(@"注册成功");
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

@end
