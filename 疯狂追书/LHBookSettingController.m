//
//  LHBookSettingController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-30.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHBookSettingController.h"

@interface LHBookSettingController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
}
@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation LHBookSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *Titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 59)];
    Titleview.backgroundColor = [UIColor colorWithRed:19/255.0 green:110/255.0 blue:156/255.0 alpha:1.0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 19, 39, 32);
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
    [Titleview addSubview:button];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2.0-20, 19, 40, 32)];
    TitleLabel.text =@"设置";
    TitleLabel.textColor = [UIColor whiteColor];
    [Titleview addSubview:TitleLabel];
    [self.view addSubview:Titleview];
    [self createTabelView];
}
- (NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
}
- (void)createTabelView{
    _dataArr = [NSArray arrayWithObjects:@"字体大小",@"夜间模式", nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, kScreenSize.width, kScreenSize.height-59) style:UITableViewStylePlain];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width-100-20, 0, 100, 30)];
        [sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:sw];
        sw.tag = 101;
    }
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)BackClick:(UIButton *)button{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    UISwitch *sw = (UISwitch *)[self.view viewWithTag:101];
    [arr addObject:[NSString stringWithFormat:@"%d", sw.on]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"notice" object:arr];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)swClick:(UISwitch *)sw{
    NSLog(@"-----%d",sw.on);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
