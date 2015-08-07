//
//  LHBaseController.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWillShow.h"
@interface LHBaseController : UIViewController<ViewWillShow>
-(NSString *)FromNow:(NSTimeInterval )late;
@end
