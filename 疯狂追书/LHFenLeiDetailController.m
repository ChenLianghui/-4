//
//  LHFenLeiDetailController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-22.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHFenLeiDetailController.h"

@interface LHFenLeiDetailController ()

@end

@implementation LHFenLeiDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self urlWithTag:self.Tag andCategory:@"get_tagbooks"];
    [self firstDownload];
    [self creatRefreshView];
    
    [self initUI];
   
}
- (void)initUI{
    UIView *Titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 59)];
    Titleview.backgroundColor = [UIColor colorWithRed:19/255.0 green:110/255.0 blue:156/255.0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 19, 39, 32);
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
    [Titleview addSubview:button];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 19, 100, 32)];
    TitleLabel.text = self.Tag;
    TitleLabel.textColor = [UIColor whiteColor];
    [Titleview addSubview:TitleLabel];
    [self.view addSubview:Titleview];
}
- (void)BackClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
