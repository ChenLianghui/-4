//
//  LHHotSearchViewController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-28.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHHotSearchViewController.h"
#import "AFNetworking.h"

#import "LHSearchResultController.h"
#import "DBManager.h"


@interface LHHotSearchViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>
{
    UISearchController *_searchVC;
    NSMutableArray *_resultArr;
    NSMutableArray *_dataArr;
}
@property (nonatomic,strong)UISearchController *searchVC;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *resultArr;
@property (nonatomic,strong)UIScrollView *ButtonView;

@end



@implementation LHHotSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSearchBar];
    [self GetData];
    self.ButtonView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width, kScreenSize.height-64-50-43-46)];
    self.ButtonView.backgroundColor = [UIColor whiteColor];
    self.ButtonView.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height*1.5);
    [self.view addSubview:self.ButtonView];
    
//    self.resultArr = [[NSMutableArray alloc] init];
//    UITableViewController *tableVC  = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
//    tableVC.tableView.delegate = self;
//    tableVC.tableView.dataSource =self;
//    [tableVC.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
//    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchVC.delegate = self;
//    self.searchVC.searchResultsUpdater = self;
//    self.searchVC.dimsBackgroundDuringPresentation = YES;
    
}

- (void)GetData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHHotSearchUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取热门搜索");
        self.dataArr = [[NSMutableArray alloc] init];
        self.dataArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dataArr:%@",self.dataArr);
        //[self creatCollectionView];
        [self addTagButtonWithArray:self.dataArr InView:self.ButtonView];
    } failure:^(AFHTTPRequestOperation *operation,NSError*error){
        NSLog(@"获取搜索失败");
    }];
}



-(void)addTagButtonWithArray:(NSArray *)arr InView:(UIScrollView *)view{
    //    view.frame = CGRectMake(27, 0, 328, 35);
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    for (int i = 0; i<arr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSString *str = arr[i];
        [button setTitle:str forState:UIControlStateNormal];
        [button.layer setBorderWidth:1];
        [button.layer setBorderColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:1.0 alpha:1.0].CGColor];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        
        [button setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.tag = 1001+i;
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [str sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, button.titleLabel.frame.size.height)];
        if (i == 0) {
            button.frame = CGRectMake(20, 20, size.width+15, 30);
            [arry addObject:button];
            
        }else{
            UIButton *Button = [UIButton buttonWithType:UIButtonTypeSystem];
            Button = arry[i-1];
            if (CGRectGetMaxX(Button.frame)+20+size.width+15+20>kScreenSize.width) {
                button.frame = CGRectMake(20, CGRectGetMaxY(Button.frame)+20, size.width+15, 30);
                [arry addObject:button];
            }else{
            button.frame = CGRectMake(20+CGRectGetMaxX(Button.frame),Button.frame.origin.y, size.width+15, 30);
            [arry addObject:button];
            }
        }
        [view addSubview:button];
        
    }
    
}


- (void)creatSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    searchBar.placeholder = @"输入书名或者作者名";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text =@"";
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    LHSearchResultController *search = [[LHSearchResultController alloc] init];
    search.KeyWord = searchBar.text;
    if ([[DBManager sharedManager] isExistKeyWord:search.KeyWord recordType:kLZXBrowses]) {
        [[DBManager sharedManager] deleteKeyWord:search.KeyWord recordType:kLZXBrowses];
    }
    [[DBManager sharedManager] insertKeyWord:search.KeyWord recordType:kLZXBrowses];
    [self presentViewController:search animated:YES completion:nil];
}


- (void)BtnClick:(UIButton *)button{
    NSString *bookName = [[NSString alloc] init];
    bookName = [self.dataArr objectAtIndex:button.tag-1001];
    LHSearchResultController *search = [[LHSearchResultController alloc] init];
    search.KeyWord = bookName;
    if ([[DBManager sharedManager] isExistKeyWord:bookName recordType:kLZXBrowses]) {
        [[DBManager sharedManager] deleteKeyWord:bookName recordType:kLZXBrowses];
    }
    [[DBManager sharedManager] insertKeyWord:bookName recordType:kLZXBrowses];
    [self presentViewController:search animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
