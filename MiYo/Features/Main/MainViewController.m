//
//  MainViewController.m
//  MiYo
//
//  Created by 项小盆友 on 16/3/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "MainViewController.h"
#import "CommonsDefines.h"
#import "MessageModel.h"
#import "SearchViewController.h"
#import "Util.h"

@interface MainViewController ()<UITabBarControllerDelegate>
@property (strong, nonatomic) UIButton *dashboardButton;
@property (assign, nonatomic) NSInteger newIndex;
@property (strong, nonatomic) NSTimer *messageTimer;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.tabBar setTintColor:[UIColor whiteColor]];
    self.delegate = self;
    _newIndex = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToNewView) name:@"NewView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TurnToMainView) name:@"LogoutSuccess" object:nil];
    
    
    UIImage *homepageImage = [UIImage imageNamed:@"tab_homepage"];
    UIImage *homepageImageSelected = [UIImage imageNamed:@"tab_homepage_selected"];
    homepageImage = [homepageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homepageImageSelected = [homepageImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *collectionImage = [UIImage imageNamed:@"tab_collection"];
    UIImage *collectionImageSelected = [UIImage imageNamed:@"tab_collection_selected"];
    collectionImage = [collectionImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    collectionImageSelected = [collectionImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *messageImage = [UIImage imageNamed:@"tab_message"];
    UIImage *messageImageSelected = [UIImage imageNamed:@"tab_message_selected"];
    messageImage = [messageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageImageSelected = [messageImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *personalImage = [UIImage imageNamed:@"tab_personal"];
    UIImage *personalImageSelected = [UIImage imageNamed:@"tab_personal_selected"];
    personalImage = [personalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalImageSelected = [personalImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *searchImage = [UIImage imageNamed:@"tab_search"];
    UIImage *searchImageSelected = [UIImage imageNamed:@"tab_search_selected"];
    searchImage = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    searchImageSelected = [searchImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    /*首页*/
    UIViewController *homepageViewController = [[UIStoryboard storyboardWithName:@"Homepage" bundle:nil] instantiateViewControllerWithIdentifier:@"HomepageView"];
    [self setupChildControllerWith:homepageViewController normalImage:homepageImage selectedImage:homepageImageSelected title:@""];
    
    /*收藏*/
    UIViewController *collectionViewController = [[UIStoryboard storyboardWithName:@"Collection" bundle:nil] instantiateViewControllerWithIdentifier:@"CollectionView"];
    [self setupChildControllerWith:collectionViewController normalImage:collectionImage selectedImage:collectionImageSelected title:@""];
    
    /**
     *  搜索
     */
    UIViewController *searchViewController = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchView"];
    [self setupChildControllerWith:searchViewController normalImage:searchImage selectedImage:searchImageSelected title:@""];
    
    /*消息*/
    UIViewController *messageViewController = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageView"];
    [self setupChildControllerWith:messageViewController normalImage:messageImage selectedImage:messageImageSelected title:@""];
    
    /*个人中心*/
    UIViewController *personalViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalView"];
    [self setupChildControllerWith:personalViewController normalImage:personalImage selectedImage:personalImageSelected title:@""];
    
//    /*中间按钮*/
//    [self.tabBar setUpTabBarCenterButton:^(UIButton * _Nullable centerButton) {
////        [centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
////        
////        [centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];
//        [centerButton setBackgroundColor:[UIColor redColor]];
//        
//        [centerButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
//    }];
//    _dashboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _dashboardButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2 - 22.5, 2, 43.5, 43.5);
//    _dashboardButton.backgroundColor = [UIColor clearColor];
//    [_dashboardButton setBackgroundImage:[UIImage imageNamed:@"tab_search"] forState:UIControlStateNormal];
//    [_dashboardButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBar addSubview:_dashboardButton];
    
    if ([Util isLogin]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchUnreadMessage) name:@"FetchUnreadMessage" object:nil];
        _messageTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchUnreadMessage) userInfo:nil repeats:YES];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LogoutSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FetchUnreadMessage" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupChildControllerWith:(UIViewController *)childViewController normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childViewController];
    childViewController.title = title;
    childViewController.tabBarItem.image = normalImage;
    childViewController.tabBarItem.selectedImage = selectedImage;
    childViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7.0, 0, - 7.0, 0);
    
    [self addChildViewController:navigationController];
}

#pragma mark - UITabBar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    _newIndex = index;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (![Util isLogin]) {
        if ((viewController != [tabBarController.viewControllers objectAtIndex:0]) && (viewController != [tabBarController.viewControllers objectAtIndex:2])) {
            if (tabBarController.selectedIndex == 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HomepageHaveNotLogin" object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchHaveNotLogin" object:nil];
            }
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)chickCenterButton
{
    NSLog(@"点击了中间按钮");
    SearchViewController *searchViewController = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchView"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
- (void)turnToNewView {
    self.selectedIndex = _newIndex;
}
- (void)TurnToMainView {
    self.selectedIndex = 0;
}
- (void)fetchUnreadMessage {
    [MessageModel fetchUnreadQualityWith:^(id object, NSString *msg) {
        if (!msg) {
            NSInteger quality = [object[@"count"] integerValue];
            if (quality > 0) {
                self.tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%@", @(quality)];
            }
        }
    }];
}

@end
