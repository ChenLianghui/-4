//
//  LHThemeDetailController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-22.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHThemeDetailController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ThemeListModel.h"
#import "ArticleModel.h"
#import "BoyFavCell.h"
#import "BookSummaryController.h"

@interface LHThemeDetailController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
- (IBAction)BackBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *ThemeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ThemeDecLabel;
@property (nonatomic)ThemeListModel *listModel;


@end

@implementation LHThemeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self GetDataWithId:self.ThemeId];
    [self initUI];
}
- (void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 130, kScreenSize.width-40, kScreenSize.height-160) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"BoyFavCell" bundle:nil] forCellReuseIdentifier:@"BoyFavCell"];
    
}
- (void)GetDataWithId:(NSString *)ThemeId{
    NSString *url = nil;
    url = [NSString stringWithFormat:ThemeDetailUrl,self.ThemeId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取主题列表");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        _listModel = [[ThemeListModel alloc] init];
        [_listModel setValuesForKeysWithDictionary:dict];
        self.ThemeTitleLabel.text = self.listModel.title;
        
        self.ThemeDecLabel.text =self.listModel.desc;
        
        NSArray *booklistArr = [dict valueForKey:@"booklist"];
        self.dataArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in booklistArr) {
            ArticleModel *model = [[ArticleModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArr addObject:model];
            
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation,NSError* error){
        NSLog(@"获取主题列表失败");
    }];
}
#pragma mark - UItableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BoyFavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoyFavCell" forIndexPath:indexPath];
    ArticleModel *model = [self.dataArr objectAtIndex:indexPath.row];
    cell.TitleLabel.text = model.book_name;
    cell.AuthorLabel.text = [NSString stringWithFormat:@"作者:%@",model.author];
    cell.SummaryLabel.text = model.shortIntro;
    [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookSummaryController *book = [[BookSummaryController alloc] init];
    ArticleModel *model =[self.dataArr objectAtIndex:indexPath.row];
    book.bookId = model.bookid;
//    [self.navigationController pushViewController:book animated:YES];
    [self presentViewController:book animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)BackBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
