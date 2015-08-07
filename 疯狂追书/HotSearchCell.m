//
//  HotSearchCell.m
//  疯狂追书
//
//  Created by qianfeng01 on 15-7-16.
//  Copyright (c) 2015年 陈良辉. All rights reserved.
//

#import "HotSearchCell.h"
#import "UIImageView+WebCache.h"
@implementation HotSearchCell

-(void)setModel:(ArticleModel *)model{
    _model = model;
    [self.IconImage sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.TitleLabel.text = model.book_name;
}

- (void)awakeFromNib {
    
}

@end
