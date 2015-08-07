//
//  ThemeListModel.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-22.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHModel.h"

@interface ThemeListModel : LHModel
@property (nonatomic,copy)NSString *update_date;
@property (nonatomic,copy)NSString *author_nickname;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic)int collectorCount;
@property (nonatomic)int author_lv;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSArray *booklist;
@end
