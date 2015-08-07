//
//  BookSummaryController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-21.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "BookSummaryController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ArticleModel.h"
#import "LHFenLeiDetailController.h"
#import "LHSearch_AuthorController.h"
#import "LHMuluController.h"
#import "LHReadController.h"
#import "DBManager.h"
#import "LHTieBaController.h"
@interface BookSummaryController ()
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *BookNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *CatalogBtn;

@property (weak, nonatomic) IBOutlet UIButton *TagBtn;
@property (weak, nonatomic) IBOutlet UIButton *AuthorBtn;


- (IBAction)TieBaClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *StateLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *AddFavBtn;

- (IBAction)ReadBtn:(UIButton *)sender;

- (IBAction)BackBtn:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet UILabel *SummaryLabel;
@property (nonatomic) ArticleModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *IconImage;

@end

@implementation BookSummaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetDataWithBookId:self.bookId];

   
    [self setButton];
    
    
    
}

- (void)GetDataWithBookId:(long)bookId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = nil;
    url = [NSString stringWithFormat:LHBookDetailUrl,self.bookId];
    NSLog(@"url:%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"获取详情数据");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.model = [[ArticleModel alloc] init];
        [self.model setValuesForKeysWithDictionary:dict];
        [self.IconImage sd_setImageWithURL:[NSURL URLWithString:self.model.icon] placeholderImage:nil];
        self.TitleLabel.text = self.model.book_name;
        NSLog(@"title:%@",self.TitleLabel.text);
        [self.TagBtn setTitle:self.model.type forState:UIControlStateNormal];
        [self.TagBtn addTarget:self action:@selector(MoreTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.AuthorBtn setTitle:self.model.author forState:UIControlStateNormal];
        [self.AuthorBtn addTarget:self action:@selector(Search_author:) forControlEvents:UIControlEventTouchUpInside];
        self.StateLabel.text = self.model.status;
        self.TimeLabel.text = [self FromNow:self.model.update_date];
        self.SummaryLabel.text = self.model.comment;
        self.BookNameLabel.text = self.model.book_name;
        [self GetFirstUrl];
        NSString *BOOKID = [NSString stringWithFormat:@"%ld",self.model.bookid];
        BOOL isExist = [[DBManager sharedManager] isExistAppForAppId:BOOKID recordType:kLZXFavorite];
        [self.AddFavBtn setTitle:@"已收藏" forState:UIControlStateDisabled];
        
        [self.AddFavBtn setTitle:@"收藏" forState:UIControlStateNormal];
        if (isExist) {
            self.AddFavBtn.enabled = NO;
        }else{
            
            self.AddFavBtn.enabled = YES;
        }
        [self.AddFavBtn addTarget:self action:@selector(AddFavClick:) forControlEvents:UIControlEventTouchUpInside];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"获取详情失败");
    }];
}
- (void)setButton{
    [self.CatalogBtn.layer setMasksToBounds:YES];
    [self.CatalogBtn.layer setCornerRadius:5.0];
    [self.CatalogBtn.layer setBorderWidth:1.0];
    [self.CatalogBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.CatalogBtn addTarget:self action:@selector(EnterMulu:) forControlEvents:UIControlEventTouchUpInside];
    self.SummaryLabel.baselineAdjustment = UIBaselineAdjustmentNone;
    

}
- (void)EnterMulu:(UIButton *)button{
    LHMuluController *mulu = [[LHMuluController alloc] init];
    mulu.bookId = self.model.bookid;
    mulu.title = self.model.book_name;
    [self presentViewController:mulu animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)MoreTag:(UIButton *)button{
    LHFenLeiDetailController *fenlei = [[LHFenLeiDetailController alloc] init];
    fenlei.Tag = self.model.type;
    //[self.navigationController pushViewController:fenlei animated:YES];
    [self presentViewController:fenlei animated:YES completion:nil];
    
}
- (void)Search_author:(UIButton *)button{
    LHSearch_AuthorController *author = [[LHSearch_AuthorController alloc] init];
    author.Author = self.model.author;
    //[self.navigationController pushViewController:author animated:YES];
    [self presentViewController:author animated:YES completion:nil];
}
- (void)GetFirstUrl{
    NSString *url = [NSString stringWithFormat:LHBookMuluUrl,self.model.bookid];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSLog(@"成功");
        NSArray *arry = [[NSArray alloc] init];
        arry= [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict1 = [arry firstObject];
        self.link = [[NSString alloc] init];
        self.link = [dict1 objectForKey:@"link"];
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"失败");
    }];
   

}

- (void)AddFavClick:(UIButton *)button{
    button.enabled = NO;
    [[DBManager sharedManager] insertModel:self.model recordType:kLZXFavorite];
}

- (IBAction)BackBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)ReadBtn:(UIButton *)sender {
  
    LHReadController *read =[[LHReadController alloc] init];
    
    read.bookID = self.bookId;
    NSLog(@"url1:%@",_link);
    NSLog(@"url2:%@",self.FirstUrl);
    read.url =self.link ;
    [self presentViewController:read animated:YES completion:nil];
}
- (IBAction)TieBaClick:(UIButton *)sender {
    LHTieBaController *tieBa = [[LHTieBaController alloc] init];
    tieBa.Tag = self.model.book_name;
    [self presentViewController:tieBa animated:YES completion:nil];
}
@end
