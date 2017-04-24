//
//  UIViewControllerExtension.m
//  Client
//
//  Created by qq on 2016/11/23.
//  Copyright © 2016年 qq. All rights reserved.
//

#import "UIViewControllerExtension.h"
#import "dimensions.h"
#import "UIViewControllerExtension.h"

int const Tag_StatusView = 20161124;
int const Tag_shadowView = 20170216;

@implementation UIViewController(Extension)

-(UIViewController*)controllerById:(NSString*)identifier storyboard:(NSString*)storyboard{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    if(identifier == nil){
        return [sb instantiateInitialViewController];
    }else{
        return [sb instantiateViewControllerWithIdentifier:identifier];
    }
}

-(void) setStatusBarBgColor:(UIColor*)color offY:(CGFloat)offset{
    
    UIView *statusView = [self.view viewWithTag:Tag_StatusView];
    if(statusView != nil){
        [statusView removeFromSuperview];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, offset, SCREEN_WIDTH, 20)];
    view.tag=Tag_StatusView;
    view.backgroundColor=color;
    [self.view addSubview:view];
    //        app.window!.sendSubviewToBack(view)
}
-(UIView*)statusBarView{
    return [self.view viewWithTag:Tag_StatusView];
}
-(void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigateTo:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

/// 在指定 View 的上方添加几个重叠的阴影
-(void)addTopShadows:(NSInteger)shadowNum belowAtView:(UIView*)belowAtView toView:(UIView*)toView
             bgColor:(UIColor*)bgColor borderColor:(UIColor*)borderColor edgeWidth:(CGFloat)edgeWidth{
    belowAtView.layer.borderColor = borderColor.CGColor;
    belowAtView.layer.borderWidth = 0.5;
    
    UIView* aboveView = belowAtView;
    
    for(UIView* v in toView.subviews){// 清除原来绘制的阴影
        if(v.tag == Tag_shadowView){
            [v removeFromSuperview];
        }
    }
    
    for(int i = 0 ; i< shadowNum; i++){
        CGRect rect = aboveView.frame;
        
        CGFloat offsetX = rect.size.width;
        
        rect.size.width = rect.size.width * 0.9;
        rect.size.height = 10;
        
        rect.origin.y -= edgeWidth;
        
        offsetX = (offsetX-rect.size.width)/2;
        rect.origin.x += offsetX;
        
        UIView * belowView = [[UIView alloc]initWithFrame:rect];
        belowView.backgroundColor = bgColor;
        belowView.layer.cornerRadius = 4;
        belowView.layer.borderColor = borderColor.CGColor;
        belowView.layer.borderWidth = 0.5;
        belowView.clipsToBounds = YES;
        belowView.tag = Tag_shadowView;
        
        [toView insertSubview:belowView belowSubview:aboveView];
        aboveView = belowView;
        
    }
}
@end

