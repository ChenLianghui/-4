//
//  HotSearchCell.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"
@interface HotSearchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@property (nonatomic)ArticleModel *model;
@end
