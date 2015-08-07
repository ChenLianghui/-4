//
//  ThemesModel.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-18.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "LHModel.h"

@interface ThemesModel : LHModel
-(id)valueForUndefinedKey:(NSString *)key;
@property (nonatomic,copy)NSString *update_date;
@property (nonatomic,copy)NSString *author_nickname;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic)int collectorCount;
@property (nonatomic)int author_lv;
@property (nonatomic,copy)NSString *title;
/*
 "update_date": "2015-06-01 14:25:33",
 "author_nickname": "白墨",
 "id": "546ab024f0dd6c552fee8fe8",
 "created": "2014-11-18 02:34:12",
 "icon": "http://statics.",
 "desc": "历史类架空小说，喜欢历史的不容错过噢！",
 "collectorCount": "6",
 "author_lv": "4",
 "title": "文笔-情节（历史）"
 */
@end
