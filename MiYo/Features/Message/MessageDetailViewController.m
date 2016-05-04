//
//  MessageDetailViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "FetchMessageDetailRequest.h"
#import "HousingDetailViewController.h"
#import "UserCardViewController.h"

@interface MessageDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cardButton;
@property (weak, nonatomic) IBOutlet UIButton *housingButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *portraitWidthConstraint;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cardButton.layer.masksToBounds = YES;
    _cardButton.layer.cornerRadius = 4.0;
    _cardButton.layer.borderWidth = 0.5;
    _cardButton.layer.borderColor = [Util turnToRGBColor:@"12c1e8"].CGColor;
    
    _housingButton.layer.masksToBounds = YES;
    _housingButton.layer.cornerRadius = 4.0;
    _housingButton.layer.borderWidth = 0.5;
    _housingButton.layer.borderColor = [Util turnToRGBColor:@"12c1e8"].CGColor;
    
    
    if ([_model.type integerValue] == 1) {
        self.navigationItem.title = @"合租消息";
        _portraitWidthConstraint.constant = 60;
        [_portraitImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_model.headphoto]] placeholderImage:[UIImage imageNamed:@"icon_hezu"]];
        _contentLabel.text = [NSString stringWithFormat:@"%@希望能跟你合租，及时联系噢~", _model.nickname];
        _cardButton.hidden = NO;
        _housingButton.hidden = NO;
    } else {
        self.navigationItem.title = @"系统消息";
        _portraitWidthConstraint.constant = 0;
        _contentLabel.text = [NSString stringWithFormat:@"%@", _model.content];
        _cardButton.hidden = YES;
        if ([Util isEmpty:_model.houseid]) {
            _housingButton.hidden = YES;
        } else {
            _housingButton.hidden = NO;
        }
    }
    NSString *timeString = _model.time;
    timeString = [timeString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *timeDate = [Util getTimeDate:timeString];
    if ([[Util compareDate:timeDate] isEqualToString:@"今天"]) {
        timeString = [timeString substringWithRange:NSMakeRange(11, 5)];
    } else if ([[Util compareDate:timeDate] isEqualToString:@"昨天"]) {
        timeString = [NSString stringWithFormat:@"昨天%@", [timeString substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    _timeLabel.text = timeString;
    
    [self fetchMessageDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchMessageDetail {
    [[FetchMessageDetailRequest new] request:^BOOL(FetchMessageDetailRequest *request) {
        request.messageId = _model.id;
        return YES;
    } result:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cardButtonClick:(id)sender {
    if (![Util isEmpty:_model.senduserid]) {
        UserCardViewController *cardViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"UserCardView"];
        cardViewController.userId = _model.senduserid;
        [self.navigationController pushViewController:cardViewController animated:YES];
    }
}
- (IBAction)housingButton:(id)sender {
    if (![Util isEmpty:_model.houseid]) {
        HousingDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HousingDetailView"];
        detailViewController.housingId = _model.houseid;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
