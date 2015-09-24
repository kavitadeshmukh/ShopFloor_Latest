//
//  TabBarViewController.m
//  ShopFloor
//
//  Created by Kavita Deshmukh on 10/09/15.
//  Copyright (c) 2015 Infosys. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    // set background color ot tababr
    [self.tabBar setTintColor:[UIColor colorWithRed:255/255.0
                                              green:102/255.0
                                               blue:0/255.0
                                              alpha:1]];
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.translucent = NO;
    [[self.viewControllers objectAtIndex:0] setTitle:@"Dashboards"];
    [[self.viewControllers objectAtIndex:1] setTitle:@"Applications"];
    [[self.viewControllers objectAtIndex:2] setTitle:@"Reports"];
    
    UITabBarController *tabBarController = self;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    // set images to tabbar
    tabBarItem1.image =[[UIImage imageNamed:@"icon_dashboard.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage =[[UIImage imageNamed:@"icon_dashboard_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image =[[UIImage imageNamed:@"icon_applications.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage =[[UIImage imageNamed:@"icon_applications_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image =[[UIImage imageNamed:@"icon_reports.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage =[[UIImage imageNamed:@"icon_reports_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
