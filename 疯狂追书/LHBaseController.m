//
//  LHBaseController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHBaseController.h"

@interface LHBaseController ()

@end

@implementation LHBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(NSString *)FromNow:(NSTimeInterval )late{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSString *timeString = @"";
    NSTimeInterval cha = now - late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f",cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if ([timeString isEqualToString:@"0"]) {
            timeString = @"刚刚";
        }else{
            timeString = [NSString stringWithFormat:@"%@分钟前",timeString];
        }
        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f",cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前",timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    if (cha/31536000>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/31536000];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@年前",timeString];
    }
    return timeString;
}

-(void)viewWillShow{
    
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
