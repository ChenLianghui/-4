//
//  LHSearchResultController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-28.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHSearchResultController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ArticleModel.h"
#import "BoyFavCell.h"
#import "BookSummaryController.h"
@interface LHSearchResultController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic)ArticleModel *model;
@end

@implementation LHSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewinit];
    [self GetData];
}
- (void)tableViewinit{
    UIView *Titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 59)];
    Titleview.backgroundColor = [UIColor colorWithRed:19/255.0 green:110/255.0 blue:156/255.0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 19, 39, 32);
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
    [Titleview addSubview:button];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 19, 100, 32)];
    TitleLabel.text = self.KeyWord;
    TitleLabel.textColor = [UIColor whiteColor];
    [Titleview addSubview:TitleLabel];
    [self.view addSubview:Titleview];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, kScreenSize.width, kScreenSize.height-59) style:UITableViewStylePlain];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"BoyFavCell" bundle:nil] forCellReuseIdentifier:@"BoyFavCell"];
    [self.view addSubview:self.tableView];
}
- (void)GetData{
    NSString *url = nil;
    url = [NSString stringWithFormat:LHSearchResultUrl,self.KeyWord];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        self.dataArr = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in arr) {
            self.model = [[ArticleModel alloc] init];
            [self.model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:self.model];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"搜索结果获取失败");
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BoyFavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoyFavCell" forIndexPath:indexPath];
    [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:self.model.icon] placeholderImage:nil];
    self.model = [self.dataArr objectAtIndex:indexPath.row];
    cell.TitleLabel.text = self.model.book_name;
    cell.AuthorLabel.text =self.model.author;
    cell.SummaryLabel.text =self.model.comment;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookSummaryController *book = [[BookSummaryController alloc] init];
    self.model = [self.dataArr objectAtIndex:indexPath.row];
    book.bookId = self.model.bookid;
    [self presentViewController:book animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)BackClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
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
