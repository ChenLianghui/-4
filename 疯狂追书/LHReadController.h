//
//  LHReadController.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-24.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHReadController : UIViewController
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *url;
@property (nonatomic)NSInteger totalPages;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic,strong)UILabel *Text;
@property (nonatomic,strong)UILabel *Text2;
@property (nonatomic)long bookID;
@end
