//
//  LHSearchController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-27.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHSearchController.h"
#import "LHHotSearchViewController.h"
#import "LHSearchedViewController.h"
#import "SCNavTabBarController.h"

@interface LHSearchController ()

@end

@implementation LHSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self viewControllerInit];
    
}


- (void)viewControllerInit{
    NSArray *vcArrs = @[@"LHHotSearchViewController",@"LHSearchedViewController"];
    NSArray *titles = @[@"热门搜索",@"搜索历史"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i <vcArrs.count; i++) {
        Class myClass = NSClassFromString(vcArrs[i]);
        UIViewController *vc = [[myClass alloc] init];
        vc.title = titles[i];
        [arr addObject:vc];
    }
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = [NSArray arrayWithArray:arr];
    [navTabBarController addParentController:self];
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
