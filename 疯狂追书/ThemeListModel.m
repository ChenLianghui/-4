//
//  ThemeListModel.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-22.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "ThemeListModel.h"

@implementation ThemeListModel
@synthesize id = _id;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
        if ([key isEqualToString:@"id"]) {
            
            self.id = value;
        }
}

@end
