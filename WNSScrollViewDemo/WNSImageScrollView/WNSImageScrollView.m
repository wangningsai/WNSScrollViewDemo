//
//  WNSImageScrollView.m
//  WNSScrollViewDemo
//
//  Created by 祁 on 15/12/15.
//  Copyright © 2015年 王宁赛. All rights reserved.
//

#import "WNSImageScrollView.h"
@interface WNSImageScrollView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *mainScrollView;

@property (nonatomic,strong) UIPageControl *mainPageController;

@property (nonatomic,assign) CGFloat widthOfView;

@property (nonatomic,assign) CGFloat heightView;

@property (nonatomic,strong) NSArray *imagesNameArray;

@property (nonatomic,strong) NSMutableArray *imageViewsArray;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) UIViewContentMode imageViewcontentModel;

@property (nonatomic,strong) UIPageControl *imageViewPageControl;

@property (nonatomic,strong) TapImageViewButtonBlock block;

@property (nonatomic,assign) BOOL isRight;

@end
@implementation WNSImageScrollView

#pragma -----便利构造器
+ (instancetype)zlImageScrollViewWithFrame:(CGRect)frame WithImages:(NSArray *)images
{
    WNSImageScrollView *instance = [[WNSImageScrollView alloc]initWithFrame:frame WithImages:images];
    
    return instance;
}

#pragma ------mark 遍历初始化方法
- (instancetype)initWithFrame:(CGRect)frame WithImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //获取滚动视图的高度
        _widthOfView = frame.size.width;
        
        //获取滚动视图的高度
        _heightView = frame.size.height;
        
        _scrollInterval = 3;
        
        _animationInterVale = 0.7;
        
        _isRight = YES;
        
        //当前显示页面
        _currentPage = 0;
        
        _imageViewcontentModel = UIViewContentModeScaleAspectFill;
        
        self.clipsToBounds = YES;
        
        _imagesNameArray = images;
        
        //初始化滚动视图
        [self initMainScrollView];
        
        //添加ImageView
        [self addImageViewsForMainScrollWithImageView];
        
        //添加timer
        [self addTimerLoop];
        
        [self addpageControl];
    }
    return self;
}

#pragma 添加PageControl
-(void)addpageControl
{
    _imageViewPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
    
    _imageViewPageControl.numberOfPages = _imagesNameArray.count;
    
    _imageViewPageControl.currentPage = _currentPage - 1;
    
    _imageViewPageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    _imageViewPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self addSubview:_imageViewPageControl];
}

-(void) addTapEventForImageWithBlock:(TapImageViewButtonBlock)block
{
    if (_block == nil)
    {
        if (block!= nil)
        {
            _block = block;
            
            [self initImageViewButton];
        }
    }
}

#pragma --mark 初始化按钮
- (void) initImageViewButton
{
    for (int i = 0; i < _imageViewsArray.count + 1; i++)
    {
        CGRect currentFrame = CGRectMake(_widthOfView*i,  0, _widthOfView, _heightView);
       
        UIButton *tempButton = [[UIButton alloc]initWithFrame:currentFrame];
        
        [tempButton addTarget:self action:@selector(tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            tempButton.tag = _imageViewsArray.count;
        }
        else
        {
            tempButton.tag = i;
        }
        
        [_mainScrollView addSubview:tempButton];
    }
}

-(void)tapImageButton:(UIButton *)sender
{
    if (_block)
    {
        _block(_currentPage + 1);
    }
}
#pragma --make 初始化ScrollView
- (void) initMainScrollView
{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _widthOfView, _heightView)];
    
    _mainScrollView.contentSize = CGSizeMake(_widthOfView, _heightView);
    
    _mainScrollView.pagingEnabled = YES;
    
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    
    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    _mainScrollView.delegate = self;
    
    [self addSubview:_mainScrollView];
}

#warning   就这两个方法不一样

#pragma -- mark  给ScrollView添加ImageView 3个 ImageView
- (void) addImageViewsForMainScrollWithImageView
{
    //设置ContentSize
    _mainScrollView.contentSize = CGSizeMake(_widthOfView*2, _heightView);
    
    _imageViewsArray = [[NSMutableArray alloc]initWithCapacity:2];
    
    //创建两个ImageView
    for (int i = 0; i<2; i++)
    {
        CGRect currentFrame = CGRectMake(_widthOfView *i, 0, _widthOfView, _heightView);
        
        UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:currentFrame];
        
        
        tempImageView.contentMode = _imageViewcontentModel;
        
        tempImageView.clipsToBounds = YES;
        
        [_mainScrollView addSubview:tempImageView];
        
        
        //数组里放的是两个imageView
        [_imageViewsArray addObject:tempImageView];
    }
    
    
    //给第一张ImageView设置图片
    UIImageView *tempImageView = _imageViewsArray[0];
    ///本地图片显示
    [tempImageView setImage:[UIImage imageNamed:_imagesNameArray[0]]];
    ///显示网上图片(有bug)
//     [tempImageView setImage:[UIImage imageWithData:_imagesNameArray[0]]];
    
}

- (void) changeOffset
{
    //获取ScrollView的offset.x
    
    _currentPage ++ ;
    
    //如果是最后一张图片，让其成为第一个（滚动一轮了）
    if (_currentPage >= _imagesNameArray.count)
    {
        //当前是最后一张图片
        
        _currentPage = 0;
    }
    
    //将要显示的视图
    if (_currentPage < _imagesNameArray.count)
    {
        //拿出第二张imageView
        UIImageView *tempImageView = _imageViewsArray[1];
        
        //拿出数组中的第currentpage个图片展示到第二张ImageView上
        
         ///本地图片显示
        [tempImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        
        ///显示网上图片（有bug）
//        [tempImageView setImage:[UIImage imageWithData:_imagesNameArray[0]]];

        
    }
    
    
    //决定滑动的方向
    [UIView animateWithDuration:_animationInterVale animations:^{
        if (_isRight)
        {
            _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
        }
        else
        {
            _mainScrollView.contentOffset = CGPointMake(-_widthOfView, 0);
        }
    }
     completion:^(BOOL finished) {
         //说明是用的第二个ImageView     不是最后一张
         if (_currentPage < _imagesNameArray.count)
         {
             //每次都让scrollView滚动到原来的位置
             _mainScrollView.contentOffset = CGPointMake(0, 0);
             
             
             //当前用的第二张ImageView，拿出第一个ImageView显示下一张
             UIImageView *tempImageView = _imageViewsArray[0];
             
              ///本地图片显示
             [tempImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
             
             ///显示网上图片（有bug）
//             [tempImageView setImage:[UIImage imageWithData:_imagesNameArray[0]]];

         }
     }
     ];
    _imageViewPageControl.currentPage = _currentPage;
}

-(void)addTimerLoop
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetx = scrollView.contentOffset.x - 0;
    if (offsetx > 3)
    {
        [self LoopRightWithBool:YES];
        return;
    }
    if (offsetx < -3)
    {
        [self LoopRightWithBool:NO];
        return;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _currentPage ++;
    //如果是最后一个图片，让其成为第一个
    if (_currentPage >= _imagesNameArray.count)
    {
        _currentPage = 0;
       
    }
    //将要显示的视图
    if (_currentPage < _imagesNameArray.count)
    {
        UIImageView *tempImageVIew = _imageViewsArray[1];
        
         ///本地图片显示
        [tempImageVIew setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        
        ///显示网上图片（有bug）
//        [tempImageVIew setImage:[UIImage imageWithData:_imagesNameArray[0]]];

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   //说明是用的第二个ImageView
    if (_currentPage < _imagesNameArray.count)
    {
        _mainScrollView.contentOffset = CGPointMake(0, 0);
        
        UIImageView *tempImageView = _imageViewsArray[0];
     
            ///本地图片显示
        [tempImageView setImage:[UIImage imageNamed:_imagesNameArray[_currentPage]]];
        
        ///显示网上图片（有bug）
//        [tempImageView setImage:[UIImage imageWithData:_imagesNameArray[0]]];

    }
    
    _imageViewPageControl.currentPage = _currentPage;
    
    [self resumeTimer];
    
}

#pragma 暂停定时器
-(void)resumeTimer
{
    if (![_timer isValid])
    {
        return;
    }
    
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
}

#pragma 改变方向
-(void)LoopRightWithBool:(BOOL)isRight
{
    _isRight = isRight;
    
    UIImageView *secondImageView = _imageViewsArray[1];
    
    if (isRight)
    {
        secondImageView.frame = CGRectMake(_widthOfView, 0, _widthOfView, _heightView);
        
    }
    else
    {
        secondImageView.frame = CGRectMake(_widthOfView, 0, _widthOfView, _heightView);
        
    }
}
@end
