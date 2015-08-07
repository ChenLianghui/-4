//
//  LHFenLeiController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-22.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHFenLeiController.h"
#import "FenLeiCell.h"
#import "AFNetworking.h"
#import "LHFenLeiHeaderView.h"
#import "LHFenLeiDetailController.h"
@interface LHFenLeiController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArr;
    NSMutableArray *_MaleArr;
    NSMutableArray *_FemaleArr;
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *MaleArr;
@property (nonatomic,strong)NSMutableArray *FemaleArr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation LHFenLeiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateView];
    [self GetData];
    self.title = @"分类";
}
- (void)CreateView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenSize.width/3.2, 50);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate =self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FenLeiCell" bundle:nil] forCellWithReuseIdentifier:@"FenLeiCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LHFenLeiHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FenLeiHeader"];
    [self.view addSubview:self.collectionView];
}
- (void)GetData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LHFenLeiUrl parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"分类获取成功");
        self.dataArr = [[NSMutableArray alloc] init];
        self.MaleArr = [[NSMutableArray alloc] init];
        self.FemaleArr = [[NSMutableArray alloc] init];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic1 = [dic valueForKey:@"data"];
        self.MaleArr = [dic1 valueForKey:@"male"];
        self.FemaleArr = [dic1 valueForKey:@"female"];
        [self.dataArr addObject:self.MaleArr];
        [self.dataArr addObject:self.FemaleArr];
        [self.collectionView reloadData];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"分类获取失败");
    }];
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.MaleArr.count;
    }else{
        return self.FemaleArr.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FenLeiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FenLeiCell" forIndexPath:indexPath];
//    [cell.TagLabel.layer setBorderWidth:1];
//    [cell.TagLabel.layer setBorderColor:[[UIColor grayColor] CGColor]];
    if (indexPath.section == 0) {
        cell.TagLabel.text = [self.MaleArr objectAtIndex:indexPath.row];
    }else{
        cell.TagLabel.text = [self.FemaleArr objectAtIndex:indexPath.row];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LHFenLeiHeaderView *view = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FenLeiHeader" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [view.iconImage setImage:[UIImage imageNamed:@"ic_boy"]];
            view.SexLabel.text = @"男生";
        }else{
            [view.iconImage setImage:[UIImage imageNamed:@"ic_girl"]];
            view.SexLabel.text = @"女生";
        }
        
    }
    return view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 50);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LHFenLeiDetailController *detail = [[LHFenLeiDetailController alloc] init];
    if (indexPath.section == 0) {
        detail.Tag = [self.MaleArr objectAtIndex:indexPath.row];
    }else{
        detail.Tag = [self.FemaleArr objectAtIndex:indexPath.row];
    }
    NSLog(@"tag:%@",detail.Tag);
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
