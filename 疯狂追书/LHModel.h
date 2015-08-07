//
//  LHModel.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-17.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHModel : NSObject
//防止kvc 赋值的时候 崩溃
//如果kvc 赋值  通过key 找不到对应的属性名 会调用下面的方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
- (id)valueForUndefinedKey:(NSString *)key;
@end
