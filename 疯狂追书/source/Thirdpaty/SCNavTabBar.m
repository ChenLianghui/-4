//
//  SCNavTabBar.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCNavTabBar.h"


@interface SCNavTabBar ()
{
    UIScrollView    *_navgationTabBar;      // all items on this scroll view
    UIButton     *_arrowButton;          // arrow button
    
    UIView          *_line;                 // underscore show which item selected will show this view
    NSMutableArray  *_items;                // SCNavTabBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
}

@end

@implementation SCNavTabBar

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initConfig];
        _currentItemIndex = 0;
    }
    return self;
}
- (void)refresh {
    
}
#pragma mark -
#pragma mark - Private Methods

- (void)initConfig
{
    _items = [@[] mutableCopy];
    _arrowImage = [UIImage imageNamed: @"add"];
    
    [self viewConfig];
}

- (void)viewConfig
{
    CGFloat functionButtonX = kScreenSize.width;
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, functionButtonX, 44)];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}
- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(8.0f, 44.0 - 3.0f, width, 3.0f)];
    
    _line.backgroundColor = [UIColor colorWithRed:87/255.0f green:121/255.0f blue:210/255.0f alpha:1];
    [_navgationTabBar addSubview:_line];
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 0;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(index*90, 5, 80, 44);
        // 100 长度
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
//        if (index == 0) {
//            [button setTitleColor:[UIColor colorWithRed:87/255.0f green:121/255.0f blue:210/255.0f alpha:1] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//        }else {
//            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:16];
//        }
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += 60;
    }
    
    [self showLineWithButtonWidth:80];
    [self setCurrentItemIndex:0];
    return buttonX;
}


- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
}
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    for (NSInteger i = 0; i<titles.count; i++) {
        NSNumber *width = [NSNumber numberWithFloat:44.0f];
        [widths addObject:width];
    }
    return widths;
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}




#pragma mark -
#pragma mark - Public Methods
- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowImage = arrowImage ? arrowImage : _arrowImage;
    [_arrowButton setBackgroundImage:_arrowImage forState:UIControlStateNormal];
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    for (NSInteger index = 0; index<_items.count; index++) {
        UIButton *itemButton = _items[index];
        if (index == _currentItemIndex) {
            [itemButton setTitleColor:[UIColor colorWithRed:87/255.0f green:121/255.0f blue:210/255.0f alpha:1] forState:UIControlStateNormal];
            itemButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }else {
            [itemButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            itemButton.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    CGFloat flag = kScreenSize.width - 44;
    
    if (button.frame.origin.x + button.frame.size.width > flag)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            offsetX = offsetX + 40.0f;
        }
        
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x, _line.frame.origin.y, 80, _line.frame.size.height);
    }];
}

- (void)updateData
{
    _arrowButton.backgroundColor = self.backgroundColor;
    
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}




#pragma mark - SCFunctionView Delegate Methods
#pragma mark -
- (void)itemPressedWithIndex:(NSInteger)index
{
    [_delegate itemDidSelectedWithIndex:index];
}

@end

