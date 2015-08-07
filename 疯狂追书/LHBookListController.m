//
//  LHBookListController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-20.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHBookListController.h"
#import "AFNetworking.h"
#import "ThemesModel.h"
#import "ThemeCell.h"
#import "UIImageView+WebCache.h"
#import "CLHHelper.h"
#import "JHRefresh.h"
#import "ArticleModel.h"
#import "BoyFavCell.h"
#import "LHThemeDetailController.h"
#import "BookSummaryController.h"
@interface LHBookListController ()<UITableViewDataSource,UITableViewDelegate>



@end

@implementation LHBookListController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.category isEqualToString:@"get_zhuti"]) {
        static NSInteger index = 0;
        CGRect frame = self.tableView.frame;
        NSLog(@"-------%d",self.isReturn);
        if (self.isReturn) {
            index = 1;
//            frame.origin.y = 35+20;
            frame.origin.y = 59+30;
        }
        self.tableView.frame = frame;
    }
    
    [self.tableView reloadData];
    
}
-(NSString *)urlWithTag:(NSString *)tag andCategory:(NSString *)category{
    _tag = tag;
    _category = category;
    NSString *sUrl = [NSString stringWithFormat:LHZuiReUrl,(long)self.currentPage, _tag,_category];
    //由于分类里面的tag值为汉字，得到的URL中有汉字，在解析的时候成为无效的URL，所以在这编译一下
    sUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)sUrl, nil, nil, kCFStringEncodingUTF8));
    return sUrl;
    
}
-(void)createTableView{
    //主题书单
    if ([self.category isEqualToString:@"get_zhuti"]) {
        NSLog(@"category1:%@",self.category);
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenSize.width, kScreenSize.height-59) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor blackColor];
    }
    //按类型或者作者进入
    else if ([self.category isEqualToString:@"get_tagbooks"]||[self.category isEqualToString:@"search_author"]) {
        NSLog(@"category2:%@",self.category);
        self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,59, kScreenSize.width, kScreenSize.height-59) style:UITableViewStylePlain];
    }
    else{
        NSLog(@"category3:%@",self.category);
        //消除导航栏影响
        self.automaticallyAdjustsScrollViewInsets=NO;
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-49-64) style:UITableViewStylePlain];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, kScreenSize.width, kScreenSize.height-59-30) style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BoyFavCell" bundle:nil] forCellReuseIdentifier:@"BoyFavCell"];
    
    [self.view addSubview:self.tableView];
}
- (void)creatRefreshView{
    __weak typeof (self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.currentPage = 1;
        NSString *url = nil;
        //url = [weakSelf url: weakSelf.tag];
        url = [weakSelf urlWithTag:weakSelf.tag andCategory:weakSelf.category];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.currentPage++;
        NSString *url = nil;
        //url = [weakSelf url:weakSelf.tag];
        //url = [NSString stringWithFormat:LHZuiReUrl,weakSelf.currentPage,weakSelf.tag,weakSelf.category];
        url = [weakSelf urlWithTag:weakSelf.tag andCategory:weakSelf.category];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
}
-(void)endRefreshing{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}

- (void)firstDownload{
    self.currentPage = 1;
    self.dataArr = [[NSMutableArray alloc] init];
    NSString *url;
    //url = [self url:self.tag];
    // url = [NSString stringWithFormat:LHZuiReUrl,self.currentPage,self.tag,self.category];
    url = [self urlWithTag:self.tag andCategory:self.category];
    [self addTaskWithUrl:url isRefresh:NO];
    [self createTableView];
    
}
-(void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = @"加载中";
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    }completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
    NSString *path = [CLHHelper getFullPathWithFile:url];
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:path];
    BOOL isTimeout = [CLHHelper isTimeOutWithFile:url timeOut:24*60*60];
    if ((isRefresh = NO)&&(isExist == YES)&&(isTimeout == NO)) {
        NSData *data = [NSData dataWithContentsOfFile:[CLHHelper getFullPathWithFile:url]];
        if (self.currentPage == 1) {
            [self.dataArr removeAllObjects];
        }
        
            NSArray *JsonArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
            for (NSDictionary *dict in JsonArr) {
                if ([self.category isEqualToString:@"get_zhuti"]) {
                ThemesModel *model = [[ThemesModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dict];
                
                    [self.dataArr addObject:model];
                }else {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [self.dataArr addObject:model];
                }

            }
       
        [self.tableView reloadData];
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *parameter = @{@"":@""};
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *Operation,id responseObject){
        
        NSLog(@"获取排行数据");
        if (responseObject) {
            if (weakSelf.currentPage == 1) {
                [weakSelf.dataArr removeAllObjects];
                NSData *data = (NSData *)responseObject;
                [data writeToFile:[CLHHelper getFullPathWithFile:url] atomically:YES];
            }
            NSArray *JsonArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (isRefresh) {
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dict in JsonArr) {
                if ([self.category isEqualToString:@"get_zhuti"]) {
                ThemesModel *model = [[ThemesModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                    [self.dataArr addObject:model];
                }else {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [self.dataArr addObject:model];
                }
            }
            //NSLog(@"dataArr:%@",self.dataArr);
        }
        [weakSelf.tableView reloadData];
        
        [weakSelf endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        NSLog(@"获取排行数据失败");
        
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BoyFavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoyFavCell" forIndexPath:indexPath];
    if ([self.category isEqualToString:@"get_zhuti"]) {
        
        ThemesModel *model = [self.dataArr objectAtIndex:indexPath.row];
        cell.TitleLabel.text = model.title;
        cell.AuthorLabel.text = [NSString stringWithFormat:@"作者:%@",model.author_nickname];
        cell.SummaryLabel.text = model.desc;
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        return cell;
    }
    else
    {
        
        ArticleModel *model = [self.dataArr objectAtIndex:indexPath.row];
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        cell.TitleLabel.text = model.book_name;
        cell.AuthorLabel.text = [NSString stringWithFormat:@"作者:%@",model.author];
        cell.SummaryLabel.text = model.comment;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.category isEqualToString:@"get_zhuti"]) {
        LHThemeDetailController *detail = [[LHThemeDetailController alloc] init];
        ThemesModel *model = [self.dataArr objectAtIndex:indexPath.row];
        detail.ThemeId = model.id;
        NSLog(@"id%@",detail.ThemeId);
        //[self.navigationController pushViewController:detail animated:YES];
        //detail.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        static NSInteger i = 0;
        i = 1;
        if (i == 1) {
            self.isReturn = YES;
        }
        else{
            self.isReturn = NO;
            
        }
        [self presentViewController:detail animated:YES completion:nil];
    }
    else
    {
        BookSummaryController *book = [[BookSummaryController alloc] init];
        ArticleModel *model = [self.dataArr objectAtIndex:indexPath.row];
        book.bookId = model.bookid;
        //[self.navigationController pushViewController:book animated:YES];
        //book.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:book animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
