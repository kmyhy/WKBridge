//
//  WKDelegate.h
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKController.h"

@interface WKBridge : NSObject

@property(strong,nonatomic)WKController* wkController;

// 以下 4 个方法分别演示了 JS 的 4 种传参方式：无参数、字典参数、字符串参数、数组参数
-(void)navBack;                     // 1. 无参数
-(void)alert:(NSArray* )data;       // 2. 字典(JSON 对象）参数
-(void)log:(NSArray* )data;         // 3. 字符串参数
-(void)sum:(NSArray* )data;         // 4. 数组参数
//////////////////////////////////////////////////////


@end
