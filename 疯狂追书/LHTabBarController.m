//
//  LHTabBarController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHTabBarController.h"
#import "LHFoundViewController.h"
#import "LHBookrackController.h"
#import "LHUserController.h"
#import "LHSearchController.h"

@interface LHTabBarController ()

@end

@implementation LHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar setHidden:YES];
    LHFoundViewController *found = [[LHFoundViewController alloc] init];
    UINavigationController *niv1 = [[UINavigationController alloc] initWithRootViewController:found];
    LHBookrackController *bookrack = [[LHBookrackController alloc] init];
    UINavigationController *niv2 = [[UINavigationController alloc] initWithRootViewController:bookrack];
    LHSearchController *search = [[LHSearchController alloc] init];
    UINavigationController *niv3 = [[UINavigationController alloc] initWithRootViewController:search];
    LHUserController *user = [[LHUserController alloc] init];
    UINavigationController *niv4 = [[UINavigationController alloc] initWithRootViewController:user];
    
    self.viewControllers = @[niv1,niv2,niv3,niv4];
    //self.viewControllers = @[found,bookrack,user];
    [self addCustomTabBar];
    self.lastSelectButton = (UIButton *)[self.view viewWithTag:101];
    self.lastHightlightedLabel = (UILabel *)[self.view viewWithTag:201];
    //[self creatControllers];
    
}
- (void)setLastHightlightedLabel:(UILabel *)lastHightlightedLabel{
    if (_lastHightlightedLabel == lastHightlightedLabel) {
        return;
    }
    _lastHightlightedLabel.textColor = [UIColor darkGrayColor];
    _lastHightlightedLabel = lastHightlightedLabel;
    _lastHightlightedLabel.textColor = [UIColor colorWithRed:0.055f green:0.671f blue:1.000f alpha:1.00f];
}
-(void)setLastSelectButton:(UIButton *)lastSelectButton{
    if (_lastSelectButton == lastSelectButton) {
        return;
    }
    _lastSelectButton.selected = NO;
    _lastSelectButton = lastSelectButton;
    _lastSelectButton.selected = YES;
}
- (void)addCustomTabBar{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, self.view.frame.size.width, 49)];
    imageView.backgroundColor = [UIColor colorWithRed:235.0/256 green:226.0/256 blue:226.0/256 alpha:1.0];
    imageView.userInteractionEnabled = YES;
    
    NSArray *imageNames =@[@"ic_home_tab1_n",@"ic_home_tab2_n",@"ic_search",@"ic_home_tab3_n"];
    NSArray *selectedNames =@[@"ic_home_tab1_p",@"ic_home_tab2_p",@"ic_search2",@"ic_home_tab3_p"];
    NSArray *Titles = @[@"发现",@"书架",@"搜索",@"我的"];
    CGFloat width = imageView.frame.size.width/4.0;
    for (int i = 0; i < 4; i++) {
        float fit = kScreenSize.width/375.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*width+20, 7, width-65*fit, 20);
        [button setBackgroundImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:selectedNames[i]] forState:UIControlStateSelected];
        [imageView addSubview:button];
        button.tag = 101+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = button.frame;
        frame.origin.y = CGRectGetMaxY(frame);
        frame.size.height = 49 - frame.size.height -5;
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor =[UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [UIColor darkGrayColor];
        label.tag = 201 + i;
        [imageView addSubview:label];
        label.text = Titles[i];
        
    }
    [self.view addSubview:imageView];
}
-(void)buttonClick:(UIButton *)button{
    self.lastSelectButton = button;
    self.lastHightlightedLabel = (UILabel *)[self.view viewWithTag:button.tag +100];
    self.selectedIndex = button.tag -101;
}
- (void)creatControllers{
    NSArray *VcNames = @[@"LHFoundViewController",@"LHBookrackController",@"LHSearchController",@"LHUserController"];
    NSArray *Titles = @[@"发现",@"书架",@"搜索",@"我的"];
    NSArray *iconImages = @[@"ic_home_tab1_n",@"ic_home_tab2_n",@"ic_search",@"ic_home_tab3_n"];
    NSArray *iconSecImages = @[@"ic_home_tab1_p",@"ic_home_tab2_p",@"ic_search2",@"ic_home_tab3_p"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:VcNames.count];
   
    
    for (int i = 0; i<VcNames.count; i++) {
        Class vcClass = NSClassFromString(VcNames[i]);
        LHBaseController *controller = [[vcClass alloc] init];
        controller.navigationItem.title = Titles[i];
        UINavigationController *nivController = [[UINavigationController alloc] initWithRootViewController:controller];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:Titles[i] image:[UIImage imageNamed:iconImages[i]] selectedImage:[UIImage imageNamed:iconSecImages[i]]];
       // nivController.tabBarItem = item;
        [viewControllers addObject:nivController];
        
    }
    self.viewControllers = viewControllers;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
