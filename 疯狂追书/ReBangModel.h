//
//  ReBangModel.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-19.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "JSONModel.h"
#import "ArticleModel.h"
@interface ReBangModel : JSONModel
@property (nonatomic,copy)NSString *tag;
@property (nonatomic,copy)NSString *tag_name;
@property (nonatomic,strong)NSArray <ArticleModel>*data;
@end
