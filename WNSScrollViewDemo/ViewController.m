//
//  ViewController.m
//  WNSScrollViewDemo
//
//  Created by 祁 on 15/12/15.
//  Copyright © 2015年 王宁赛. All rights reserved.
//

#import "ViewController.h"
#import "WNSImageScrollView.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addWNSImageScrollView];
       
}
-(void)addWNSImageScrollView
{
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen]bounds];
    
    CGRect frame = CGRectMake(10, 60, screenFrame.size.width - 20, 200);
   
    
//    NSURL *url = [NSURL URLWithString:@"http://pic.nipic.com/2008-03-11/200831115126384_2.jpg"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//
//    
//    NSURL *url2 = [NSURL URLWithString:@"http://img.61gequ.com/allimg/2011-4/201142614314278502.jpg"];
//    NSData *data2 = [NSData dataWithContentsOfURL:url2];
//
//    
//    NSURL *url3 = [NSURL URLWithString:@"http://img.7160.com/uploads/allimg/141219/9-141219100557.jpg"];
//    NSData *data3 = [NSData dataWithContentsOfURL:url3];
//
//    
//    NSURL *url4 = [NSURL URLWithString:@"http://pic1.nipic.com/2008-11-13/2008111384358912_2.jpg"];
//    NSData *data4 = [NSData dataWithContentsOfURL:url4];
//
//
//
//    NSArray *imageArray = @[data,data2,data3,data4];
//    NSLog(@"%@",imageArray);
    
    NSArray *imageArray =@ [@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"005.jpg"];
    
    
    //初始化控件
    WNSImageScrollView *imageViewDisplay = [WNSImageScrollView zlImageScrollViewWithFrame:frame WithImages:imageArray];
    
    //设定轮播时间
    imageViewDisplay.scrollInterval = 1;
    
    //图片滚动的时间
    imageViewDisplay.animationInterVale = 0.6;
    
    //把该视图添加到相应的父视图上
    [self.view addSubview:imageViewDisplay];
    
    //点击每张图片
    [imageViewDisplay addTapEventForImageWithBlock:^(NSUInteger imageIndex) {
        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片",imageIndex];
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alter show];
    }];
}
@end
