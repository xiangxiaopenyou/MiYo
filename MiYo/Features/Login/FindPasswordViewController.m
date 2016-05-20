//
//  FindPasswordViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/13.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "Util.h"
#import "XLNoticeHelper.h"
#import "GetCodeRequest.h"
#import "FindPasswordRequest.h"
#import "MBProgressHUD+Add.h"

@interface FindPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (copy, nonatomic) NSString *receivedCode;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger counterNumber;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.viewTitle;
    
    _getCodeButton.layer.masksToBounds = YES;
    _getCodeButton.layer.cornerRadius = 5.0;
    _getCodeButton.layer.borderWidth = 0.5;
    _getCodeButton.layer.borderColor = [Util turnToRGBColor:@"C9C9C9"].CGColor;
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 2.0;
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
- (IBAction)getButtonClick:(id)sender {
    if (![Util validatePhone:_phoneNumberTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请先输入正确的手机号"];
        return;
    }
    _getCodeButton.enabled = NO;
    _counterNumber = 60;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%@", @(_counterNumber)] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCounter) userInfo:nil repeats:YES];
    [[GetCodeRequest new] request:^BOOL(GetCodeRequest *request) {
        request.phoneNumber = _phoneNumberTextField.text;
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
- (IBAction)submitButtonClick:(id)sender {
    if (![Util validatePhone:_phoneNumberTextField.text]) {
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
    if ([Util isEmpty:_passwordTextField.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"请输入新密码密码"];
        return;
    }
    if (_passwordTextField.text.length < 6 || _passwordTextField.text.length > 14) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"密码要求在6-14位"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[FindPasswordRequest new] request:^BOOL(FindPasswordRequest *request) {
        request.account = _phoneNumberTextField.text;
        request.password = _passwordTextField.text;
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            [MBProgressHUD showSuccess:@"成功" toView:self.view];
            [self performSelector:@selector(popView) withObject:nil afterDelay:0.5];
            
        } else {
            [MBProgressHUD showError:@"失败" toView:self.view];
        }
    }];
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
