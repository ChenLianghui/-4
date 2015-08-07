//
//  LHMuluController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-24.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHMuluController.h"
#import "MuluModel.h"
#import "AFNetworking.h"
#import "LHReadController.h"
@interface LHMuluController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation LHMuluController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [[NSMutableArray alloc] init];
    [self initUI];
    [self GetDataWithBookId:self.bookId];
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
    TitleLabel.text = self.title;
    TitleLabel.textColor = [UIColor whiteColor];
    [Titleview addSubview:TitleLabel];
    [self.view addSubview:Titleview];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(Titleview.frame), kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
}
- (void)GetDataWithBookId:(long)bookId{
    NSString *url = [NSString stringWithFormat:LHBookMuluUrl,bookId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取目录");
        
        NSArray *arry = [[NSArray alloc] init];
        arry= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict1 = [arry firstObject];
        self.url = [dict1 objectForKey:@"link"];
        if (_myblock) {
            _myblock(self.url);
        }
        
        for (NSDictionary *dic in arry) {
            MuluModel *model = [[MuluModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"获取目录失败");
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    MuluModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LHReadController *read = [[LHReadController alloc] init];
    MuluModel *model = self.dataArr[indexPath.row];
    read.bookID = self.bookId;
    read.title = model.title;
    read.url = model.link;
    [self presentViewController:read animated:YES completion:nil];
}
- (void)BackClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setMyblock:(MyBlock)myblock{
    if (_myblock!=myblock) {
        _myblock = [myblock copy];
    }
}



@end
