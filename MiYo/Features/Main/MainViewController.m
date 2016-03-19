//
//  MainViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBar appearance] setTintColor:[UIColor colorWithWhite:0.15 alpha:1.000]];
    
    UITabBarItem *homepageItem = [[UITabBarItem alloc] init];
    homepageItem.title = @"首页";
    UIViewController *homepageViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HomepageView"];
    UINavigationController *navigation1 = [[UINavigationController alloc] initWithRootViewController:homepageViewController];
    navigation1.tabBarItem = homepageItem;
    
    UITabBarItem *collectionItem = [[UITabBarItem alloc] init];
    collectionItem.title = @"收藏";
    UIViewController *collectionViewController = [[UIStoryboard storyboardWithName:@"Collection" bundle:nil] instantiateViewControllerWithIdentifier:@"CollectionView"];
    UINavigationController *navigation2 = [[UINavigationController alloc] initWithRootViewController:collectionViewController];
    navigation2.tabBarItem = collectionItem;
    
    UITabBarItem *messageItem = [[UITabBarItem alloc] init];
    messageItem.title = @"消息";
    UIViewController *messageViewController = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageView"];
    UINavigationController *navigation3 = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    navigation3.tabBarItem = messageItem;
    
    UITabBarItem *personalItem = [[UITabBarItem alloc] init];
    personalItem.title = @"个人中心";
    UIViewController *personalViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalView"];
    UINavigationController *navigation4 = [[UINavigationController alloc] initWithRootViewController:personalViewController];
    navigation4.tabBarItem = personalItem;
    
    self.viewControllers = @[navigation1, navigation2, navigation3, navigation4];
    
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
