//
//  HousingAddressChooseViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/4/14.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HousingAddressChooseViewController.h"
#import <WebKit/WebKit.h>

@interface HousingAddressChooseViewController ()
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation HousingAddressChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.amap.com/picker/?keywords=酒店,超市,医院&key=89d199da89347317ac59f68b47145be8"]]];
    [self.view addSubview:self.webView];
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

@end
