//
//  LHUserController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHUserController.h"
#import "SDImageCache.h"

@interface LHUserController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation LHUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的";
    [self createTableView];
}

- (void)createTableView{
    self.dataArr = [NSArray arrayWithObjects:@"清除缓存",@"关于我们:769514079@qq.com", nil];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.rowHeight = 60;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *title = [NSString stringWithFormat:@"删除缓存文件:%.2fM",[self getCachesSize]];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}
- (double)getCachesSize{
    double sdSize = [[SDImageCache sharedImageCache] getSize];
    NSString *myCachePath  =[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/MyCaches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    double mySize  = 0;
    for (NSString * fileName in enumerator) {
        NSString *filePath = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        mySize += dict.fileSize;
    }
    double totalSize = (mySize + sdSize)/1024/1024;
    return totalSize;
    
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
