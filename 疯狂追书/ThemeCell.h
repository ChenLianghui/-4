//
//  ThemeCell.h
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-18.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SummaryLabel;

@end
