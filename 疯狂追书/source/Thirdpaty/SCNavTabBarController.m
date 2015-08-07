//
//  SCNavTabBarController.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"


@interface SCNavTabBarController () <UIScrollViewDelegate, SCNavTabBarDelegate>
{
    NSInteger       _currentIndex;              // current page index
    NSMutableArray  *_titles;                   // array of children view controller's title
    SCNavTabBar     *_navTabBar;                // NavTabBar: press item on it to exchange view
    UIScrollView    *_mainView;                 // content view
    NSMutableArray  *_loadArr;
}
@end

@implementation SCNavTabBarController

#pragma mark - Life Cycle
#pragma mark -

- (id)initWithShowArrowButton:(BOOL)show
{
    self = [super init];
    if (self)
    {
        _showArrowButton = show;
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subViewControllers
{
    self = [super init];
    if (self)
    {
        _subViewControllers = subViewControllers;
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        [self addParentController:viewController];
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;
{
    self = [self initWithSubViewControllers:subControllers];
    
    _showArrowButton = show;
    [self addParentController:viewController];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loadArr = [[NSMutableArray alloc] init];
    [self initConfig];
    [self viewConfig];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    // Iinitialize value
    _currentIndex = 0;
    _navTabBarColor = [UIColor whiteColor];
    
    // Load all title of children view controllers
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in _subViewControllers)
    {
        [_titles addObject:viewController.title];
    }
}

- (void)viewInit
{
    // Load NavTabBar and content view to show on window
    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(0,0, kScreenSize.width, 43) showArrowButton:NO];
    _navTabBar.delegate = self;
    _navTabBar.backgroundColor = _navTabBarColor;
    _navTabBar.lineColor = _navTabBarLineColor;
    _navTabBar.itemTitles = _titles;
    _navTabBar.arrowImage = _navTabBarArrowImage;
    [_navTabBar updateData];
    UIView *lineView = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, kScreenSize.width, 0.6)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_navTabBar addSubview:lineView];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navTabBar.frame.origin.y + _navTabBar.frame.size.height, kScreenSize.width, kScreenSize.height - _navTabBar.frame.origin.y - _navTabBar.frame.size.height - 49)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = YES;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(kScreenSize.width * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    [self.view addSubview:_navTabBar];
}

- (void)viewConfig
{
    [self viewInit];
    
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 * kScreenSize.width, 0, kScreenSize.width, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    [_loadArr addObject:@"0"];
    // Load children view controllers and add to content view
//    [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//        
//        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
//        viewController.view.frame = CGRectMake(idx * kScreenSize.width, 0, kScreenSize.width, _mainView.frame.size.height);
//        [_mainView addSubview:viewController.view];
//        [self addChildViewController:viewController];
//    }];
}

#pragma mark - Public Methods
#pragma mark -
- (void)setNavTabbarColor:(UIColor *)navTabbarColor
{
    // prevent set [UIColor clear], because this set can take error display
    CGFloat red, green, blue, alpha;
    if ([navTabbarColor getRed:&red green:&green blue:&blue alpha:&alpha] && !red && !green && !blue && !alpha)
    {
        navTabbarColor = [UIColor whiteColor];
    }
    _navTabBarColor = navTabbarColor;
}

- (void)addParentController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

#pragma mark - Scroll View Delegate Methods
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _currentIndex = scrollView.contentOffset.x / kScreenSize.width;
    
    NSArray *arr = [NSArray arrayWithArray:_loadArr];
    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)_currentIndex];
    
    if ([arr containsObject:indexStr]) {
        return;
    }
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * kScreenSize.width, 0, kScreenSize.width, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    [_loadArr addObject:indexStr];
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = scrollView.contentOffset.x / kScreenSize.width;
    _navTabBar.currentItemIndex = _currentIndex;
}
#pragma mark - SCNavTabBarDelegate Methods
#pragma mark -
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    [_mainView setContentOffset:CGPointMake(index * kScreenSize.width, 0) animated:_scrollAnimation];
    _navTabBar.currentItemIndex = index;
}

- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, height + 44);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, 44);
        }];
    }
    [_navTabBar refresh];
}

@end

