//
//  LHFoundViewController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHFoundViewController.h"
#import "HotSearchCell.h"
#import "AFNetworking.h"

#import "BoyFavCell.h"
#import "UIImageView+WebCache.h"
#import "ThemesModel.h"
#import "ThemeCell.h"
#import "jingpinModel.h"
#import "LHRank2Controller.h"
#import "ContainerViewController.h"
#import "ArticleModel.h"
#import "BookSummaryController.h"
#import "LHZuiReViewController.h"
#import "LHPublicController.h"
#import "LHShouCangController.h"
#import "LHThemeDetailController.h"
#import "LHFenLeiController.h"
@interface LHFoundViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>

//存放热搜和精品排行
@property(nonatomic,strong)NSMutableArray *HotArr;
//存放男生
@property(nonatomic,strong)NSMutableArray *BoyArr;
@property(nonatomic,strong)NSMutableArray *GirlArr;
//存放主题书单
@property(nonatomic,strong)NSMutableArray *ThemeArr;
@property(nonatomic,strong)NSMutableArray *SortArr;
@property(nonatomic,strong)NSMutableArray *JingpinArr;
@property(nonatomic,strong)UICollectionView *HotSearchCollectionView;
@property(nonatomic,strong)UITableView *BoyFavView;
@property (weak, nonatomic) IBOutlet UIView *BoyView;

@property (weak, nonatomic) IBOutlet UIScrollView *FullView;
@property (weak, nonatomic) IBOutlet UIView *HotSearchView;
@property (weak, nonatomic) IBOutlet UIView *SortView;


@property (weak, nonatomic) IBOutlet UITableView *GirlFavView;
@property (nonatomic,strong)UICollectionView *SortCollectionView;
@property (nonatomic) jingpinModel *jingModel;
@property (nonatomic) fenleiModel *fenModel;



@property (weak, nonatomic) IBOutlet UITableView *ThemeView;


@end

@implementation LHFoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    self.FullView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    self.FullView.contentSize = CGSizeMake(kScreenSize.width, 2000);
    self.FullView.bounces = NO;
    self.FullView.pagingEnabled = YES;
    self.FullView.scrollEnabled = YES;
    self.BoyFavView = [[UITableView alloc] initWithFrame:CGRectMake(0, 28, kScreenSize.width-40, 310)style:UITableViewStylePlain];
    [self.BoyView addSubview:self.BoyFavView];
    [self initCollectionView];
    [self initCollectionData];
    [self initBoyData];
    [self initGirlData];
    [self initThemeData];
    [self initSortCollectionView];
    [self getSortData];
    self.title = @"发现";
    
//    self.FullView.userInteractionEnabled = YES;
}
//男生
-(void)initBoyData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHMainUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取男生专题");
        if (responseObject) {
            self.BoyArr = [[NSMutableArray alloc] init];
            
            NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
                NSArray *dataArr = [Array[1] valueForKey:@"data"];
                for (NSDictionary *dataDic in dataArr) {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dataDic];
                    [self.BoyArr addObject:model];
                }
                [self.BoyFavView reloadData];
            [self initFavView:self.BoyFavView];
        }
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        NSLog(@"获取男生数据失败");
    }];

}
-(void)initGirlData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHMainUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取女生专题");
        if (responseObject) {
            
            self.GirlArr = [[NSMutableArray alloc] init];
            
            NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *dataArr = [Array[2] valueForKey:@"data"];
            for (NSDictionary *dataDic in dataArr) {
                ArticleModel *model = [[ArticleModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [self.GirlArr addObject:model];
            }
            [self.GirlFavView reloadData];
            [self initFavView:self.GirlFavView];
        }
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        NSLog(@"获取女生数据失败");
    }];
    
}
-(void)initThemeData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHMainUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取主题书单");
        if (responseObject) {
            
            self.ThemeArr = [[NSMutableArray alloc] init];
            
            NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *dataArr = [Array[4] valueForKey:@"zhuti_data"];
            for (NSDictionary *dataDic in dataArr) {
                ThemesModel *model = [[ThemesModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [self.ThemeArr addObject:model];
            }
            [self.ThemeView reloadData];
            [self initFavView:self.ThemeView];
        }
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        NSLog(@"获取主题书单失败");
    }];
    
}
-(void)initFavView:(UITableView *)TableView{
    
    TableView.dataSource =self;
    TableView.delegate =self;
    if (TableView == self.ThemeView) {
        [TableView registerNib:[UINib nibWithNibName:@"ThemeCell" bundle:nil] forCellReuseIdentifier:@"ThemeCell"];
    }else{
    [TableView registerNib:[UINib nibWithNibName:@"BoyFavCell" bundle:nil] forCellReuseIdentifier:@"BoyFavCell"];
    }
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.BoyFavView) {
        return self.BoyArr.count;
        
    }else if(tableView == self.GirlFavView){
        return self.GirlArr.count;
    }else{
        return self.ThemeArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.BoyFavView) {
        ArticleModel *model = self.BoyArr[indexPath.row];
        BoyFavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoyFavCell" forIndexPath:indexPath];
        
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        cell.TitleLabel.text = model.book_name;
        cell.TagLabel.text = model.type;
        cell.AuthorLabel.text = [NSString stringWithFormat:@"作者:%@",model.author];
        cell.SummaryLabel.text = model.shortIntro;
        return cell;
    }else if (tableView == self.GirlFavView) {
        ArticleModel *model = self.GirlArr[indexPath.row];
        BoyFavCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BoyFavCell" forIndexPath:indexPath];
        
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        cell.TitleLabel.text = model.book_name;
        cell.TagLabel.text = model.type;
        cell.AuthorLabel.text = [NSString stringWithFormat:@"作者:%@",model.author];
        cell.SummaryLabel.text = model.shortIntro;
        return cell;

    }else{
        ThemesModel *model = self.ThemeArr[indexPath.row];
        ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell" forIndexPath:indexPath];
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
        cell.TitleLabel.text = model.title;
        cell.SummaryLabel.text = model.desc;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.BoyFavView) {
        //男生
        BookSummaryController *book = [[BookSummaryController alloc] init];
        ArticleModel *model = self.BoyArr[indexPath.row];
        book.bookId = model.bookid;
//        [self.navigationController pushViewController:book animated:YES];
        [self presentViewController:book animated:YES completion:nil];
    }else if (tableView == self.GirlFavView){
        BookSummaryController *book = [[BookSummaryController alloc] init];
        ArticleModel *model = self.GirlArr[indexPath.row];
        book.bookId = model.bookid;
        //[self.navigationController pushViewController:book animated:YES];
        [self presentViewController:book animated:YES completion:nil];
    }else{
         //主题书单
        LHThemeDetailController *theme = [[LHThemeDetailController alloc] init];
        ThemesModel *Tmodel = self.ThemeArr[indexPath.row];
        //NSLog(@"id:%@",Tmodel.id);
        theme.ThemeId = Tmodel.id;
        //[self.navigationController pushViewController:theme animated:YES];
        theme.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:theme animated:YES completion:nil];
    }
    
}


- (NSMutableArray *)HotArr{
    if (_HotArr == nil) {
        _HotArr = [[NSMutableArray alloc] init];
    }
    return _HotArr;
}
-(void)initCollectionData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHMainUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取热榜数据");
        if (responseObject) {
            NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           // NSLog(@"Array:%@",Array);
            
            NSArray *dataArr = [Array[0] valueForKey:@"data"];
            for (NSDictionary *dataDic in dataArr) {
                ArticleModel *model = [[ArticleModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
               // NSLog(@"modle:%@",model);
                [_HotArr addObject:model];
            }
            
            [self.HotSearchCollectionView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        NSLog(@"获取数据失败");
    }];
}

-(void)initCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
//    flowLayout.sectionInset = UIEdgeInsetsMake(20, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(90*KfitWidth, 155*KfitHigth);
    
    self.HotSearchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-40*KfitWidth, 320)collectionViewLayout:flowLayout];
    self.HotSearchCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.HotSearchCollectionView.delegate =self;
    self.HotSearchCollectionView.dataSource =self;
    [self.HotSearchCollectionView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellWithReuseIdentifier:HotSearchCellID];
    [self.HotSearchView addSubview:self.HotSearchCollectionView];
}

- (IBAction)rankBtn:(UIButton *)sender {
    LHRank2Controller *rank = [[LHRank2Controller alloc] init];
    [self.navigationController pushViewController:rank animated:YES];
//    [self presentViewController:rank animated:YES completion:nil];
}
- (IBAction)themeBtn:(UIButton *)sender {
    
    LHZuiReViewController *zuire = [[LHZuiReViewController alloc] init];
    zuire.title = @"本周最热";
    LHPublicController *pub = [[LHPublicController alloc] init];
    pub.title = @"最新发布";
    LHShouCangController *shoucang = [[LHShouCangController alloc] init];
    shoucang.title = @"最多收藏";
    NSMutableArray *Array = [[NSMutableArray alloc] initWithObjects:zuire,pub,shoucang, nil];
    ContainerViewController *contain =[[ContainerViewController alloc] init];
    contain.viewControllers = [NSArray arrayWithArray:Array];
    //[self.navigationController pushViewController:contain animated:YES];
    [self presentViewController:contain animated:YES completion:nil];
}
- (IBAction)sort:(UIButton *)sender {
    LHFenLeiController *fenlei = [[LHFenLeiController alloc] init];
    [self.navigationController pushViewController:fenlei animated:YES];
    //[self presentViewController:fenlei animated:YES completion:nil];
}
- (IBAction)randomBtn:(id)sender {
    BookSummaryController *book = [[BookSummaryController alloc] init];
    long bookID = arc4random()%10000;
     book.bookId = bookID;
//    [self.navigationController pushViewController:book animated:YES];
    [self presentViewController:book animated:YES completion:nil];
}
- (IBAction)BoyMoveBtn:(UIButton *)sender {
    LHFenLeiController *fenlei = [[LHFenLeiController alloc] init];
    [self.navigationController pushViewController:fenlei animated:YES];
    //[self presentViewController:fenlei animated:YES completion:nil];
}
- (IBAction)GirlMoveBtn:(UIButton *)sender {
    LHFenLeiController *fenlei = [[LHFenLeiController alloc] init];
    [self.navigationController pushViewController:fenlei animated:YES];
    //[self presentViewController:fenlei animated:YES completion:nil];
}
- (IBAction)JingPinBtn:(id)sender {
    LHRank2Controller *rank = [[LHRank2Controller alloc] init];
    [self.navigationController pushViewController:rank animated:YES];
    //[self presentViewController:rank animated:YES completion:nil];
}
- (IBAction)ThemeMoveBtn:(UIButton *)sender {
    LHZuiReViewController *zuire = [[LHZuiReViewController alloc] init];
    zuire.title = @"本周最热";
    LHPublicController *pub = [[LHPublicController alloc] init];
    pub.title = @"最新发布";
    LHShouCangController *shoucang = [[LHShouCangController alloc] init];
    shoucang.title = @"最多收藏";
    NSMutableArray *Array = [[NSMutableArray alloc] initWithObjects:zuire,pub,shoucang, nil];
    ContainerViewController *contain =[[ContainerViewController alloc] init];
    contain.viewControllers = [NSArray arrayWithArray:Array];
    [self.navigationController pushViewController:contain animated:YES];
}
-(void)initSortCollectionView{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.SortCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, kScreenSize.width-20, 350) collectionViewLayout:flowlayout];
    [self.SortView addSubview:self.SortCollectionView];
    self.SortCollectionView.backgroundColor =[UIColor whiteColor];
    
    self.SortCollectionView.delegate = self;
    self.SortCollectionView.dataSource =self;
    self.SortCollectionView.pagingEnabled = YES;
    self.SortCollectionView.contentSize = CGSizeMake(kScreenSize.width*3, 350);
    
    [self.SortCollectionView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellWithReuseIdentifier:HotSearchCellID];
}
-(void)getSortData{
    self.SortArr = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHMainUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取专题");
        if (responseObject) {
            self.JingpinArr = [[NSMutableArray alloc] init];
            NSArray *Array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.jingModel = [[jingpinModel alloc] initWithDictionary:Array[3] error:nil];
            NSLog(@"count:%ld",(unsigned long)self.jingModel.jingpin_data.count);
            [self.SortCollectionView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *Operation,NSError *error){
        NSLog(@"获取数据失败");
    }];
}

#pragma mark -  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView==self.SortCollectionView) {
        NSLog(@"count2:%ld",(unsigned long)self.jingModel.jingpin_data.count);
        return self.jingModel.jingpin_data.count;
    }else{
    return 1;
    }
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==self.SortCollectionView) {
        self.fenModel = self.jingModel.jingpin_data[section];
        return 6;
    }else{

    return self.HotArr.count;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotSearchCellID forIndexPath:indexPath];
    if (collectionView==self.SortCollectionView) {
//        jinpinDataModel *dataModel =self.fenModel.data[indexPath.row];
        self.fenModel = self.jingModel.jingpin_data[indexPath.section];
        jinpinDataModel *dataModel = self.fenModel.data[indexPath.row];
        [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:dataModel.icon] placeholderImage:nil];
        cell.TitleLabel.text = dataModel.book_name;
        return cell;
    }else{
    
    ArticleModel *Hmodel = self.HotArr[indexPath.row];
    cell.model = Hmodel;
    return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(90*KfitWidth,155*KfitHigth);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"section: %ld row: %ld", indexPath.section, indexPath.row);

    BookSummaryController *book = [[BookSummaryController alloc] init];
    if (collectionView==self.SortCollectionView) {
        self.fenModel = self.jingModel.jingpin_data[indexPath.section];
        jinpinDataModel *dataModel = self.fenModel.data[indexPath.row];
        book.bookId = dataModel.bookid;
        
    }else{
        ArticleModel *model = [[ArticleModel alloc] init];
        model = self.HotArr[indexPath.row];
        book.bookId = model.bookid;
    }
    
//    [self.navigationController pushViewController:book animated:YES];
    [self presentViewController:book animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
