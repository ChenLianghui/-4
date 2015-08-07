//
//  CLHHelper.h
//  ContainerDemo
//
//  Created by qianfeng01 on 15-7-7.
//  Copyright (c) 2015年 Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLHHelper : NSObject
+(NSString *)getFullPathWithFile:(NSString *)urlName;
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut;
@end
