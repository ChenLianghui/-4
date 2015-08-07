//
//  CLHHelper.m
//  ContainerDemo
//
//  Created by qianfeng01 on 15-7-7.
//  Copyright (c) 2015年 Zhen. All rights reserved.
//

#import "CLHHelper.h"
#import "NSString+Hashing.h"
@implementation CLHHelper
+(NSString *)getFullPathWithFile:(NSString *)urlName{
    //先获取 沙盒中document路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *myCacheDirectory = [docPath stringByAppendingPathComponent:@"MyCaches"];
    //检测MyCaches 文件夹是否存在
    if (![[NSFileManager defaultManager]fileExistsAtPath:myCacheDirectory]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:myCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //用MD5进行加密 转化为 一串十六进制数字 （MD5加密可以把一个字符串转化为一串唯一的用十六进制表示的串）
    NSString *newName = [urlName MD5Hash];
    //拼接路径
    return [myCacheDirectory stringByAppendingPathComponent:newName];
    
}
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut{
    //获取文件属性
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    //获取文件的上次修改时间
    NSDate *lastModfyDate = fileDict.fileModificationDate;
    //算出时间差 获取当前系统时间 和 lastModfydate 时间差
    NSTimeInterval sub = [[NSDate date]timeIntervalSinceDate:lastModfyDate];
    if (sub < 0) {
        sub = -sub;
    }
    if (sub > timeOut) {
        //超时
        return YES;
    }
    return NO;
}
@end
