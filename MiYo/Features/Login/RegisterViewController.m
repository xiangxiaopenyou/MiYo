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

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (copy, nonatomic) NSString *receivedCode;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger counterNumber;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    NSInteger offset;
    //if (textField == _nicknameTextField) {
    offset = 345 - (viewHeight - 252);
//    } else {
//        offset = 345 - (viewHeight - 252);
//    }
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.2f];
    if (offset > 0) {
        self.view.frame = CGRectMake(0, - offset, viewWidth, viewHeight);
    }
    [UIView commitAnimations];
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
    _getCodeButton.enabled = NO;
    _counterNumber = 60;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%@", @(_counterNumber)] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCounter) userInfo:nil repeats:YES];
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
- (void)timeCounter {
    if (_counterNumber == 0) {
        [_getCodeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        _getCodeButton.enabled = YES;
    } else {
        _counterNumber -= 1;
        [_getCodeButton setTitle:[NSString stringWithFormat:@"%@", @(_counterNumber)] forState:UIControlStateNormal];
    }
}
- (IBAction)registerClick:(id)sender {
    [_nicknameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
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
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 14) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"密码要求在6-14位"];
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
- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:0.1f];
    self.view.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    [UIView commitAnimations];
}

@end
