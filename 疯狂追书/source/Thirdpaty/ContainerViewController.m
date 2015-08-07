//
//  ContainerViewController.m
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import "ContainerViewController.h"
#import "Topbar.h"
#import "ViewWillShow.h"

@interface ContainerViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Topbar *topbar;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation ContainerViewController

- (id)initWithViewControllers:(NSArray *)viewControllers {
    if (self = [super init]) {
        _viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *Titleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 59)];
    Titleview.backgroundColor = [UIColor colorWithRed:19/255.0 green:110/255.0 blue:156/255.0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(15, 19, 39, 32);
    [button setBackgroundImage:[UIImage imageNamed:@"ic_back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(BackClick:) forControlEvents:UIControlEventTouchUpInside];
    [Titleview addSubview:button];
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 19, 100, 32)];
    TitleLabel.text = @"主题书单";
    TitleLabel.textColor = [UIColor whiteColor];
    [Titleview addSubview:TitleLabel];
    [self.view addSubview:Titleview];
}
- (void)BackClick:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (Topbar *)topbar {
    if (!_topbar) {
        _topbar = [[Topbar alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height+39, CGRectGetWidth(self.view.frame), kTopbarHeight)];
        //_topbar.backgroundColor = [UIColor blueColor];
        
        __block ContainerViewController *_self = self;
        _topbar.blockHandler = ^(NSInteger currentPage) {
            [_self setCurrentPage:currentPage];
        };
        [self.view addSubview:_topbar];
    }
    return _topbar;
}

// overwrite getter of property: scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topbar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kTopbarHeight-59)];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate                       = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.bounces                        = NO;
        _scrollView.pagingEnabled                  = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

// overwrite setter of property: viewControllers
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = [NSArray arrayWithArray:viewControllers];
    CGFloat x = 0.0;
    for (UIViewController *viewController in _viewControllers) {
        [viewController willMoveToParentViewController:self];
        viewController.view.frame = CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        x += CGRectGetWidth(self.scrollView.frame);
        _scrollView.contentSize   = CGSizeMake(x, _scrollView.frame.size.width);
    }
    
    self.topbar.titles = [_viewControllers valueForKey:@"title"];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.scrollView setContentOffset:CGPointMake(_currentPage*_scrollView.frame.size.width, 0) animated:NO]; //
}

- (void)layoutSubViews
{
    CGFloat x = 0.0;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize   = CGSizeMake(x, _scrollView.frame.size.width);
    //self.scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _topbar.currentPage   = currentPage;
    _currentPage = currentPage;
    [self callbackSubViewControllerWillShow];
}

// call back if scroll to special view controller
- (void)callbackSubViewControllerWillShow {
    UIViewController<ViewWillShow> *controller = [self.viewControllers objectAtIndex:self.currentPage];
    if ([controller conformsToProtocol:@protocol(ViewWillShow)] && [controller respondsToSelector:@selector(viewWillShow)]) {
        [controller viewWillShow];
    }
}

@end



