//
//  LHBookrackController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHBookrackController.h"
#import "DBManager.h"
#import "BoyFavCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"
#import "BookSummaryController.h"
#import "LHTabBarController.h"
#import "LHFoundViewController.h"

@interface LHBookrackController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSMutableArray *_removeArr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic)UILabel *ShortLabel;
@property (nonatomic,strong)UIButton *ShortButton;
@property (nonatomic,strong)NSMutableArray *removeArr;
@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)UIView *buttomView;
@property (nonatomic,strong)UIButton *addLoactionButton;
@end

@implementation LHBookrackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"书架";
    
}
- (NSMutableArray *)removeArr{
    if (_removeArr == nil) {
        _removeArr = [[NSMutableArray alloc] init];
    }
    return _removeArr;
}
-(void)viewWillAppear:(BOOL)animated{
    NSArray *arr = [[DBManager sharedManager] readModelsWithRecordType:kLZXFavorite];
    if (arr.count == 0) {
        [self initUI];
        
    }else{
        [self.ShortButton removeFromSuperview];
        
        [self.ShortLabel removeFromSuperview];
        
        [self showUI];
        //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (void)initUI{
    self.ShortLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, kScreenSize.width-40, 30)];
    self.ShortLabel.text = @"您的书架暂时还没有书,您可以";
    self.ShortLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.ShortLabel];
//    self.addLoactionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.addLoactionButton setTitle:@"添加本地书籍" forState:UIControlStateNormal];
//    self.addLoactionButton.frame = CGRectMake(40, CGRectGetMaxY(self.ShortLabel.frame)+20, kScreenSize.width-80, 25);
//    [self.addLoactionButton addTarget:self action:@selector(addBook:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.addLoactionButton];
    self.ShortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.ShortButton setTitle:@"去发现更多好书" forState:UIControlStateNormal];
    self.ShortButton.frame = CGRectMake(40, CGRectGetMaxY(self.ShortLabel.frame)+20, kScreenSize.width-80, 25);
    [self.ShortButton addTarget:self action:@selector(AddMore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ShortButton];
    //[self.view viewWithTag:101];
}
- (void)AddMore:(UIButton *)button{

    LHTabBarController *controller = [LHTabBarController alloc];
    //[self.navigationController pushViewController:controller animated:YES];
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)addBook:(UIButton *)button{
    
}

- (void)showUI{
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.editButton.tintColor = [UIColor clearColor];
    self.editButton.frame = CGRectMake(0, 0, 40, 35);
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor purpleColor] forState:UIControlStateSelected];
    [self.editButton setTitle:@"完成" forState:UIControlStateSelected];
    
    
    [self.editButton addTarget:self action:@selector(editClik:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
    self.buttomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(0, 10, kScreenSize.width, 40);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor whiteColor];
    deleteButton.tintColor = [UIColor redColor];
    [deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttomView addSubview:deleteButton];
    
    
    
    NSArray *arr = [[DBManager sharedManager] readModelsWithRecordType:kLZXFavorite];
    
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, kScreenSize.width, kScreenSize.height-49-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource =self;
        self.tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"BoyFavCell" bundle:nil] forCellReuseIdentifier:@"BoyFavCell"];
        [self.tableView setTableFooterView:_buttomView];
        
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BoyFavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoyFavCell" forIndexPath:indexPath];
    ArticleModel *modle = [self.dataArr objectAtIndex:indexPath.row];
    [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:modle.icon] placeholderImage:nil];
    cell.TitleLabel.text = modle.book_name;
    cell.AuthorLabel.text = modle.author;
    cell.SummaryLabel.text = modle.comment;
    return cell;
}
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
//    if (self.dataArr!=nil) {
//        
//    }
//    
//    
//}
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section{
//
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookSummaryController *book = [[BookSummaryController alloc] init];
    ArticleModel *modle = [self.dataArr objectAtIndex:indexPath.row];
    if (self.tableView.isEditing) {
        [self.removeArr addObject:modle];
        
    }else{
    book.bookId = modle.bookid;
    NSLog(@"bookid:%@",modle.book_name);
    [self.navigationController pushViewController:book animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing) {
        ArticleModel *model = [self.dataArr objectAtIndex:indexPath.row];
        [self.removeArr removeObject:model];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)editClik:(UIButton *)button{
    button.selected = !button.selected;
    [self.tableView setEditing:button.selected animated:YES];
}
- (void)deleteClick:(UIButton *)button{
    [self.dataArr removeObjectsInArray:self.removeArr];
    for (ArticleModel *model in self.removeArr) {
        NSString *BookId = [NSString stringWithFormat:@"%ld",model.bookid];
        [[DBManager sharedManager] deleteModelForAppId:BookId recordType:kLZXFavorite];
    }
    if (self.dataArr.count == 0) {
        //[self.buttomView removeFromSuperview];
        [self.editButton removeFromSuperview];
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
@end
