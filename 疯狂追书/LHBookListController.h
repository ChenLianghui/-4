//
//  LHBookListController.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-20.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHBaseController.h"
#import "MBProgressHUD.h"
@interface LHBookListController : LHBaseController
{
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    MBProgressHUD *HUD;
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic)BOOL isReturn;
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,copy)NSString *category;
@property (nonatomic)BOOL isRefreshing;
@property (nonatomic)BOOL isLoadMore;
@property (nonatomic) NSInteger currentPage;
- (NSString *)urlWithTag:(NSString *)tag andCategory: (NSString *)category;
- (void)creatRefreshView;
- (void)endRefreshing;
//第一次下载
- (void)firstDownload;
//增加下载任务
- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh;
@end
