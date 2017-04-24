//
//  WKJsBridge.h
//  Youxin
//
//  Created by yanghongyan on 16/7/19.
//  Copyright (c) 2016年 EPIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
typedef void (^completionBlock)(id, NSError *);
typedef void (^EnumerateMethodBlock)(NSString* methodName);
void enumerateMethodNames(Class class,NSArray* filters,EnumerateMethodBlock block);
void addMessageToWebView(NSDictionary<NSString*,NSString*>* moduleMap,NSArray* filters,WKWebView* webView,id<WKScriptMessageHandler> handler,completionBlock completion);
