//
//  WNSImageScrollView.h
//  WNSScrollViewDemo
//
//  Created by 祁 on 15/12/15.
//  Copyright © 2015年 王宁赛. All rights reserved.
//

#import <UIKit/UIKit.h>
//点击图片的Block回调，参数当前图片的索引，也就是当前的页数
typedef void (^TapImageViewButtonBlock)(NSUInteger imageIndex);

@interface WNSImageScrollView : UIView

//切换图片的时间间隔，可选，默认为3s
@property(nonatomic,assign)CGFloat scrollInterval;

//切换图片时，运动时间间隔，可选   默认为0.7s
@property(nonatomic,assign)CGFloat animationInterVale;

/***************************************
 * 功能：便利构造器
＊ 参数：滚动视图的Frame，要显示的图片数组
＊ 返回值： 该类的对象
****************************************/

+(instancetype)zlImageScrollViewWithFrame:(CGRect)frame WithImages:(NSArray *)images;

/**********************************
 *功能：便利初始化函数
 *参数：滚动视图的Frame, 要显示图片的数组
 *返回值：该类的对象
 **********************************/
-(instancetype)initWithFrame:(CGRect)frame WithImages:(NSArray *)images;

/**********************************
 *功能：为每个图片添加点击时间
 *参数：点击按钮要执行的Block
 *返回值：无
 **********************************/
-(void)addTapEventForImageWithBlock:(TapImageViewButtonBlock)block;
@end
