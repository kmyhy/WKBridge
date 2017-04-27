//
//  WKDelegate.h
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKController.h"

@class WKBridge;
@protocol WKBridgeDelegate <NSObject>

@required
@property(copy,nonatomic)NSString *callback;
@property(strong,nonatomic)WKBridge* bridge;

@end

@interface WKBridge : NSObject
@property(weak,nonatomic)WKController* wkController;

// 以下 4 个方法分别演示了 JS 的 4 种传参方式：无参数、字典参数、字符串参数、数组参数
-(void)navBack;                     // 1. 无参数
-(void)alert:(NSArray* )data;       // 2. 字典(JSON 对象）参数
-(void)log:(NSArray* )data;         // 3. 字符串参数
-(void)sum:(NSArray* )data;         // 4. 数组参数
//////////////////////////////////////////////////////

// 以下方法实现了原生回调 JS
// 调用示例 1 ：
// external.concatenate({'callback':'showResult','string1':'abc','string2':'123'});
// 其中 showResult 是定义在 window 对象下的自定义 JS 函数。
//
// 调用示例 2 ：
// external.concatenate({'callback':'showResult','string1':'abc','string2':'123'});
// alert 函数是 JS 内置函数
//
// 调用示例 3 ：
// external.concatenate({'callback':'external.Alert.alert','string1':'abc','string2':'123'});
// external.Alert.alert 调用的是原生提供的方法，注意回调这个方法时，回调参数应该是一个 JSON 字符串。

-(void)concatenate:(NSArray* )data;


//////////////////////////////////////////////////////

-(void)callbackJS:(NSString*)jsFunction result:(NSString*)result;


@end
