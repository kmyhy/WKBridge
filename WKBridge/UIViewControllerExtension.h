//
//  UIViewControllerExtension.h
//  Client
//
//  Created by qq on 2016/11/23.
//  Copyright © 2016年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Extension)
/// 从故事版中加载 ViewController
-(UIViewController*)controllerById:(NSString*)identifier storyboard:(NSString*)storyboard;
/// 设置 status bar 的背景色
-(void) setStatusBarBgColor:(UIColor*)color offY:(CGFloat)offset;
/// 获得 status bar view
-(UIView*)statusBarView;
/// 返回上一导航
-(void)navBack;
/// 在指定 View 的上方添加几个重叠的阴影
-(void)addTopShadows:(NSInteger)shadowNum belowAtView:(UIView*)belowAtView toView:(UIView*)toView bgColor:(UIColor*)bgColor borderColor:(UIColor*)borderColor edgeWidth:(CGFloat)edgeWidth;
/// 导航到指定 ViewController
-(void)navigateTo:(UIViewController*)vc;

@end
