//
//  FeedbackViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FeedbackViewController.h"
#import "XLNoticeHelper.h"
#import "Util.h"
#import "FeedbackRequest.h"
#import "MBProgressHUD+Add.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholderLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"意见反馈";
    if (_submitButton.layer.cornerRadius != 2.0) {
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 2.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""]) {
        _textViewPlaceholderLabel.hidden = YES;
    } else {
        if (range.location == 0 && range.length == 1) {
            _textViewPlaceholderLabel.hidden = NO;
        }
    }
    if (range.location >= 400) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"别超过400字哦～"];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)submitButtonClick:(id)sender {
    if ([Util isEmpty:_feedbackTextView.text]) {
        [XLNoticeHelper showNoticeAtViewController:self message:@"写点反馈内容吧"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *phoneString = [_phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (![Util validatePhone:phoneString]) {
//        []
//    }
    [[FeedbackRequest new] request:^BOOL(FeedbackRequest *request) {
        request.content = _feedbackTextView.text;
        request.mobile = phoneString;
        return YES;
    } result:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!msg) {
            [MBProgressHUD showSuccess:@"反馈成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"反馈失败" toView:self.view];
        }
    }];
}

@end
