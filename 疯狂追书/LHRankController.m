//
//  LHRankController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-19.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHRankController.h"
#import "AFNetworking.h"
#import "ReBangModel.h"
#import "RankCell.h"
#import "HotSearchCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"
@interface LHRankController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UICollectionView *_HotCollectionView;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UICollectionView *HotCollectionView;
@property (nonatomic)ArticleModel *HModel;
@property (nonatomic)ReBangModel *RModel;
@end

@implementation LHRankController

- (void)viewDidLoad {
    self.title = @"排行榜";
    [super viewDidLoad];
    [self initUI];
    [self GetData];
}
-(void)initUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 10, kScreenSize.width-40,kScreenSize.height) style:UITableViewStylePlain];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RankCell" bundle:nil] forCellReuseIdentifier:@"RankCell"];
    
}
-(void)GetData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHRankUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取排行数据成功");
        NSArray *JsonArry = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *Dic in JsonArry) {
            ReBangModel *ReModel = [[ReBangModel alloc] initWithDictionary:Dic error:nil];
            [self.dataArray addObject:ReModel];
            
        }
        [self.tableView reloadData];
//        NSLog(@"dataArray:%@",self.dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"获取排行数据失败");
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankCell" forIndexPath:indexPath];
    self.RModel = [[ReBangModel alloc] init];
    self.RModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.TagLabel.text = self.RModel.tag_name;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(90, 155);
    
    [cell.CollectionView setCollectionViewLayout:layout];
    cell.CollectionView.backgroundColor =[UIColor whiteColor];
    cell.CollectionView.dataSource =self;
    cell.CollectionView.delegate =self;
    [cell.CollectionView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellWithReuseIdentifier:HotSearchCellID];
   
//    if (_myblock) {
//        _myblock(reModel);
//    }
    //NSLog(@"tag:%@",model.tag_name);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
#pragma mark - UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 184;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotSearchCellID forIndexPath:indexPath];
//    __weak typeof(self) weakSelf = self;
//    [self setMyBlock:^(ReBangModel *reModel) {
//        weakSelf.HModel = [[HotSearchModel alloc] init];
//       weakSelf.HModel = reModel.data[indexPath.row];
//       
//    }];
    
    ArticleModel *model  =self.RModel.data[indexPath.row];
//    [cell.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
//    cell.TitleLabel.text =model.book_name;
    cell.model = model;
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)setMyBlock:(MyBlock)block
//{
//    if (_myblock !=block) {
//        _myblock = [block copy];
//    }
//}


@end
