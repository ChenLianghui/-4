//
//  LHRank2Controller.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-19.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHRank2Controller.h"
#import "AFNetworking.h"
#import "ReBangModel.h"
#import "HotSearchCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"
#import "HeaderView.h"
#import "LHRankHotController.h"
#import "BookSummaryController.h"
@interface LHRank2Controller ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    NSMutableArray *_tagArr;
    NSInteger _MySection;
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *Tag;
@property (nonatomic,strong)NSMutableArray *tagArr;
@property (nonatomic)NSInteger MySection;
@end

@implementation LHRank2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行榜";
    [self initUICollectionView];
    [self GetData];
    self.tagArr = [[NSMutableArray alloc] init];
}
-(void)initUICollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(90*KfitWidth, 155*KfitHigth);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, kScreenSize.width-40, kScreenSize.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotSearchCell" bundle:nil] forCellWithReuseIdentifier:HotSearchCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    [self.view addSubview:self.collectionView];
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
        [self.collectionView reloadData];
        //        NSLog(@"dataArray:%@",self.dataArray);
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"获取排行数据失败");
    }];
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotSearchCellID forIndexPath:indexPath];
    ReBangModel *ReModel = [self.dataArray objectAtIndex:indexPath.section];
    ArticleModel *model = [ReModel.data objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
       HeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        ReBangModel *ReModel = [self.dataArray objectAtIndex:indexPath.section];
  
        view.TitleLabel.text =ReModel.tag_name;

        view.MoreBtn.tag = indexPath.section;
        [view.MoreBtn addTarget:self action:@selector(MoreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    // 如果垂直滚动 view的width与集合视图一致, 需要设置高度
    return CGSizeMake(0, 40);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ReBangModel *ReModel = [self.dataArray objectAtIndex:indexPath.section];
    ArticleModel *model = [ReModel.data objectAtIndex:indexPath.row];
    BookSummaryController *book = [[BookSummaryController alloc] init];
    book.bookId = model.bookid;
//    [self.navigationController pushViewController:book animated:YES];
    [self presentViewController:book animated:YES completion:nil];
}
-(void)MoreClick:(UIButton *)button{
    LHRankHotController *controller = [[LHRankHotController alloc] init];
    ReBangModel *model = [self.dataArray objectAtIndex:button.tag];
    
        controller.Tag = model.tag;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
