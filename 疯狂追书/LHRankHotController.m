//
//  LHRankHotController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-20.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHRankHotController.h"
#import "LHRank2Controller.h"
@interface LHRankHotController ()

@end

@implementation LHRankHotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self urlWithTag:self.tag andCategory:@"get_top"];
    [self firstDownload];
    [self creatRefreshView];
    //NSLog(@"tag2:%lu",self.Tag);
    
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
