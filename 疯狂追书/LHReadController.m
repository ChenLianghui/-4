//
//  LHReadController.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-24.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHReadController.h"
#import "AFNetworking.h"
#import "ReadModel.h"
#import "LHBookSettingController.h"
#import "LHMuluController.h"

@interface LHReadController ()<UIWebViewDelegate,UITextViewDelegate,UIScrollViewDelegate>
@property (nonatomic)UIActivityIndicatorView *activityIndicator;
@property (nonatomic)ReadModel *model;
@property (nonatomic,strong)UITextView *book;
@property (nonatomic,strong)UIView *BookBG;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UIScrollView *ScrollView;
@property (nonatomic)float a;
@property (nonatomic)BOOL isNight;
@property (nonatomic)int totalPage;
@property (nonatomic,strong)UIView *fontView;
@end

@implementation LHReadController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.a = 19.0;
    [self GetDataWithUrl:self.url];
    
}
- (void)initUI{
    UIView *Titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 59)];
    Titleview.backgroundColor = [UIColor colorWithRed:19/255.0 green:110/255.0 blue:156/255.0 alpha:1.0];
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 19, 39, 32);
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
    [Titleview addSubview:button];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 19, 200, 32)];
    TitleLabel.text =self.title;
    TitleLabel.textColor = [UIColor whiteColor];
    [Titleview addSubview:TitleLabel];
    [self.view addSubview:Titleview];
    
//    UIButton *SetButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    SetButton.frame = CGRectMake(kScreenSize.width-40-10, 19, 40, 32);
//    [SetButton setTitle:@"设置" forState:UIControlStateNormal];
//    [SetButton addTarget:self action:@selector(Setting:) forControlEvents:UIControlEventTouchUpInside];
//    SetButton.tintColor = [UIColor whiteColor];
//    [self.view addSubview:SetButton];
    
//    _Text2 = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenSize.height-20, kScreenSize.width, 20)];
//    _Text2.backgroundColor = [UIColor colorWithRed:19/255.0 green:110/255.0 blue:156/255.0 alpha:1.0];
//    _Text2.text = @"loading";
//    _Text2.font = [UIFont fontWithName:@"Helvetica" size:12.0];
//    _Text2.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_Text2];
//    _Text2.textColor = [UIColor whiteColor];
    
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-40, kScreenSize.width, 40)];
    self.footerView.backgroundColor = [UIColor blackColor];
    NSArray *footerArr = [NSArray arrayWithObjects:@"字体大小",@"夜间模式", nil];
    for (int i = 0; i <footerArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(10+80*i, 10, 80, 20);
        [button setTitle:footerArr[i] forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.tag = 50+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:button];
    }
    _Text = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 60, 20)];
    //_Text.backgroundColor = [UIColor redColor];
    _Text.text = @"loading";
    _Text.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _Text.textColor = [UIColor whiteColor];
    _Text.textAlignment = NSTextAlignmentCenter;
    [self.footerView addSubview:_Text];
    [self.view addSubview:self.footerView];
    
    [self pagingWithTextKit];
    
    
    
}
- (void)pagingWithTextKit{
    NSString *textString = self.model.body;
    NSTextStorage *storage = [[NSTextStorage alloc] initWithString:textString];
    //添加排版
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [storage addLayoutManager:layoutManager];
    
#pragma - mark 创建ScrollView
    self.ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,59, kScreenSize.width, kScreenSize.height-59-20-20)];
    
    self.ScrollView.pagingEnabled = YES;
    self.ScrollView.bounces = NO;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
//    ScrollView.showsVerticalScrollIndicator = NO;
    self.ScrollView.delegate  =self;
    [self.view addSubview:self.ScrollView];
    int i = 0;
    while (YES) {
        NSTextContainer * textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kScreenSize.width-20, kScreenSize.height - 20-59-20-10)];
        
        [layoutManager addTextContainer:textContainer];
        
        self.book = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kScreenSize.width-20, kScreenSize.height-20-59-10-20)textContainer:textContainer];
        
        self.book.tag = 300+i;
        
        self.BookBG = [[UIView alloc] initWithFrame:CGRectMake(i*kScreenSize.width, 0, kScreenSize.width, kScreenSize.height)];
        if (self.isNight) {
            self.book.backgroundColor = [UIColor colorWithRed:23/255.0 green:32/255.0 blue:39/255.0 alpha:1.0];
            
            self.BookBG.backgroundColor = [UIColor colorWithRed:23/255.0 green:32/255.0 blue:39/255.0 alpha:1.0];
            self.book.textColor =[UIColor colorWithRed:104/255.0 green:115/255.0 blue:137/255.0 alpha:1.0];
        }else{
            self.book.backgroundColor = [UIColor clearColor];
            self.BookBG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_book_1.jpg"]];
        }
        
        //禁止滚动
        self.book.scrollEnabled = NO;
        self.book.editable = NO;
        self.book.font = [UIFont fontWithName:@"Helvetica" size:self.a];
                [self.BookBG addSubview:self.book];
        [self.ScrollView addSubview:self.BookBG];
        
        
//          [self.view addSubview:ScrollView];
        i++;
        NSRange range = [layoutManager glyphRangeForTextContainer:textContainer];
        if (range.length + range.location == textString.length) {
            self.totalPage = _ScrollView.contentSize.width/kScreenSize.width;
            break;
        }
        self.ScrollView.contentSize = CGSizeMake(i*kScreenSize.width+kScreenSize.width, kScreenSize.height-90-20);
        
    }
}
//- (void)addTapGesture{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    [tap addTarget:self action:@selector(Tap:)];
//    [self.ScrollView addGestureRecognizer:tap];
//}

//- (void)setBG:(NSNotification *)notice{
//   NSString *bg =  notice.object[0];
//    int Bg = bg.intValue;
//    NSLog(@"%d",Bg);
//    if (Bg == 0) {
//        self.book.backgroundColor = [UIColor clearColor];
//        self.BookBG.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_book_1.jpg"]];
//    }else{
//        self.book.backgroundColor = [UIColor colorWithRed:23/255.0 green:32/255.0 blue:39/255.0 alpha:1.0];
//        self.book setba
//        self.BookBG.backgroundColor = [UIColor colorWithRed:23/255.0 green:32/255.0 blue:39/255.0 alpha:1.0];
//      //  self.book.tintColor = [UIColor colorWithRed:104/255.0 green:32/255.0 blue:39/255.0 alpha:1.0];
//    }
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int a = scrollView.contentOffset.x/self.view.frame.size.width+1;
    
    _Text.text = [NSString stringWithFormat:@"%d/%d页",a,_totalPage];
//    _Text2.text = [NSString stringWithFormat:@"%d/%d页",a,b];
   

}


- (void)GetDataWithUrl:(NSString *)url{
    NSString *Url = nil;
    Url = [NSString stringWithFormat:LHReadUrl,self.url];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:Url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        //NSLog(@"----%@",responseObject);
        NSLog(@"获取图书");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dict:%@",dict);
        NSDictionary *dic = [dict objectForKey:@"chapter"];
        //NSLog(@"dic:%@",dic);
        self.model = [[ReadModel alloc] init];
        [self.model setValuesForKeysWithDictionary:dic];
        [self initUI];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"获取失败");
    }];
}
- (void)BackClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)Setting:(UIButton *)button{
    
}
- (void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 50:{
            //self.a = 25.0;
            //[self pagingWithTextKit];
            button.selected = !button.selected;
            
            if (button.selected) {
                self.fontView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-40-55, kScreenSize.width, 60)];
                self.fontView.backgroundColor = [UIColor blackColor];
                NSArray *array = [NSArray arrayWithObjects:@"ic_font_decrease",@"ic_font_plush", nil];
                for (int i = 0; i<2; i++) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
                    button.frame = CGRectMake(20+(40+20)*i, 0, 40, 40);
                    button.tag = 400+i;
                    [button addTarget:self action:@selector(changeFont:) forControlEvents:UIControlEventTouchUpInside];
                    [self.fontView addSubview:button];
                }
                [self.view addSubview:self.fontView];
                
        }
                else{
                [self.fontView removeFromSuperview];
                self.fontView = nil;
            }
            
        }
            break;
        case 51:{
            self.isNight = !self.isNight;
            NSLog(@"++++++%d",self.isNight);
            [self pagingWithTextKit];
        }
            break;
        default:
            break;
    }
}
- (void)changeFont:(UIButton *)button{
    switch (button.tag) {
        case 400:{
            self.a--;
            [self pagingWithTextKit];
        }
            break;
        case 401:{
            self.a++;
            [self pagingWithTextKit];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
