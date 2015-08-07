//
//  BookSummaryController.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-21.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHBaseController.h"

@interface BookSummaryController : LHBaseController
@property (nonatomic)long bookId;
//第一章链接
@property (nonatomic,copy)NSString *FirstUrl;
@property (nonatomic,copy)NSString *link;
@end
