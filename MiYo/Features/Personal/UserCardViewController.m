//
//  UserCardViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/5/4.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UserCardViewController.h"
#import "UserModel.h"
#import <UIImageView+AFNetworking.h>
#import "Util.h"

@interface UserCardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *livePlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UITextField *qqTextField;
@property (weak, nonatomic) IBOutlet UITextField *wechatTextField;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@end

@implementation UserCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人名片";
    [self fetchUserIdInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchUserIdInformation {
    [UserModel fetchUserIDCardWith:_userId handler:^(UserModel *object, NSString *msg) {
        if (!msg) {
            [self setupContentWith:object];
        }
    }];
}
- (void)setupContentWith:(UserModel *)model {
    _nicknameLabel.text = [NSString stringWithFormat:@"%@", model.nickname];
    [_portraitImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:model.headphoto]] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    _nameLabel.text = [Util isEmpty:model.name] ? @"姓名：未知" : [NSString stringWithFormat:@"姓名：%@", model.name];
    _ageLabel.text = [Util isEmpty:model.age] ? @"年龄：未知" : [NSString stringWithFormat:@"年龄：%@", model.age];
    _livePlaceLabel.text = [Util isEmpty:model.address] ? @"所在地：未知" : [NSString stringWithFormat:@"所在地：%@", model.address];
    _jobLabel.text = [Util isEmpty:model.job] ? @"职业：未知" : [NSString stringWithFormat:@"职业：%@", model.job];
    if ([model.sex integerValue] == 1) {
        _sexLabel.text = @"性别：男";
    } else if ([model.sex integerValue] == 2) {
        _sexLabel.text = @"性别：女";
    } else {
        _sexLabel.text = @"性别：未知";
    }
    _qqTextField.text = [Util isEmpty:model.qq] ? @"未知" : model.qq;
    _qqTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    _wechatTextField.text = [Util isEmpty:model.weichat] ? @"未知" : model.weichat;
    _wechatTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    if (![Util isEmpty:model.qq]) {
        _qqTextField.enabled = YES;
    } else {
        _qqTextField.enabled = NO;
    }
    if (![Util isEmpty:model.weichat]) {
        _wechatTextField.enabled = YES;
    } else {
        _wechatTextField.enabled = NO;
    }
    
    NSString *phoneString = [Util isEmpty:model.phone] ? @"未知" : model.phone;
    [_phoneButton setTitle:phoneString forState:UIControlStateNormal];
    if ([Util isEmpty:model.phone]) {
        _phoneButton.enabled = NO;
    } else {
        _phoneButton.enabled = YES;
        [_phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
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
- (void)phoneClick {
    NSString *phoneString = [_phoneButton.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneString]]];
}

@end
