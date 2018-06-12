//
//  TabBarViewController.m
//  ZFPlayerAVPlayerDemo
//
//  Created by Derek on 10/06/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "VideoViewController.h"
#import "FriendCircleViewController.h"
#import "MyCenterViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HomeViewController *f = [[HomeViewController alloc]init];
    f.title = @"Home";
    UINavigationController * fnav = [[UINavigationController alloc]initWithRootViewController:f];
    
    VideoViewController *s = [[VideoViewController alloc]init];
    s.title = @"Video";
    UINavigationController * snav = [[UINavigationController alloc]initWithRootViewController:s];
    
    FriendCircleViewController *t = [[FriendCircleViewController alloc]init];
    t.title = @"FriendCircle";
    UINavigationController * tnav = [[UINavigationController alloc]initWithRootViewController:t];
    
    MyCenterViewController *m = [[MyCenterViewController alloc] init];
    m.title = @"MyCenter";
    UINavigationController *mnav = [[UINavigationController alloc]initWithRootViewController:m];
    
    
    UITabBarItem * fitem = [[UITabBarItem alloc] init];
    fitem.title = @"First";
    f.tabBarItem = fitem;
    UITabBarItem * sitem = [[UITabBarItem alloc] init];
    sitem.title = @"Second";
    s.tabBarItem = sitem;
    UITabBarItem * titem = [[UITabBarItem alloc] init];
    titem.title = @"Three";
    t.tabBarItem = titem;
    UITabBarItem * mitem = [[UITabBarItem alloc] init];
    mitem.title = @"Four";
    m.tabBarItem = mitem;
    
    fitem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fitem.selectedImage = [[UIImage imageNamed:@"home_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    sitem.image = [[UIImage imageNamed:@"news"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    sitem.selectedImage = [[UIImage imageNamed:@"news_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    titem.image = [[UIImage imageNamed:@"my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    titem.selectedImage = [[UIImage imageNamed:@"my_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    mitem.image = [[UIImage imageNamed:@"my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mitem.selectedImage = [[UIImage imageNamed:@"my_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[fnav,snav,tnav,mnav];
    
    
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
