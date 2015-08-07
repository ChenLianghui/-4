//
//  fenleiModel.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-18.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "JSONModel.h"
#import "jinpinDataModel.h"
@protocol fenleiModel



@end


@interface fenleiModel : JSONModel
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *more_url;
@property (nonatomic,strong)NSArray <jinpinDataModel>*data;
@end
