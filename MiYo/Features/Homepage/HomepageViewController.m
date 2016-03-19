//
//  HomepageViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "HomepageViewController.h"
#import "LoginRequest.h"

@interface HomepageViewController ()

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"首页";
    
    [[LoginRequest new] request:^BOOL(LoginRequest *request) {
        request.username = @"admin";
        request.password = @"admin";
        return YES;
    } result:^(id object, NSString *msg) {
        
    }];
    
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
