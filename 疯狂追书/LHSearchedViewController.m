//
//  LHSearchedViewController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-28.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHSearchedViewController.h"
#import "DBManager.h"
#import "LHSearchResultController.h"
#import "SearchedCell.h"
@interface LHSearchedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation LHSearchedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
//    NSArray *arr = [[DBManager sharedManager] readModelsWithRecordType:kLZXBrowses];
    [self showUI];
}
- (void)showUI{
    
    NSArray *arr = [[DBManager sharedManager] readKeyWordsWithRecordType:kLZXBrowses];
    self.dataArr = [[NSMutableArray alloc] init];
    for (int i = arr.count-1; i>= 0; i--) {
        [self.dataArr addObject:arr[i]];
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50-43-46) style:UITableViewStylePlain];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchedCell" bundle:nil] forCellReuseIdentifier:@"SearchedCell"];
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchedCell"];
    cell.NameLabel.text = self.dataArr[indexPath.row];
    cell.DeleteBtn.tag = indexPath.row;
    [cell.DeleteBtn addTarget:self action:@selector(DeleteCell:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LHSearchResultController *search = [[LHSearchResultController alloc] init];
    search.KeyWord = self.dataArr[indexPath.row];
    [self presentViewController:search animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (void)DeleteCell:(UIButton *)button{
    NSString *keyword = [self.dataArr objectAtIndex:button.tag];
    [[DBManager sharedManager] deleteKeyWord:keyword recordType:kLZXBrowses];
    [self.dataArr removeObjectAtIndex:button.tag];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
