//
//  LHMuluController.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-24.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyBlock) (NSString *url);
@interface LHMuluController : UIViewController
{
    MyBlock _myblock;
}

@property (nonatomic)long bookId;
@property (nonatomic,copy)NSString *TitleLabel;
@property (nonatomic,copy)NSString *url;
- (void)setMyblock:(MyBlock)myblock;
@end
