//
//  WKJsBridge.m
//  Youxin
//
//  Created by yanghongyan on 16/7/19.
//  Copyright (c) 2016年 EPIC. All rights reserved.
//

#import "WKJsBridge.h"
#import "WKBridge.h"

void enumerateMethodNames(Class class,NSArray* filters,EnumerateMethodBlock block){
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(class, &methodCount);
    
    for (int i=0; i<methodCount; i++) {
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
        
        //防止隐藏的系统方法名包含“.”导致js报错
        if ([methodName rangeOfString:@"."].location!=NSNotFound) {
            continue;
        }else{
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"not(self in %@)",filters];
            if ([predicate evaluateWithObject:methodName]) {
                block(methodName);
            }
        }
    }
    free(methods);
}

void addMessageToWebView(NSDictionary<NSString*,NSString*>* moduleMap,NSArray* filters,WKWebView* webView,id<WKScriptMessageHandler> handler,completionBlock completion){
    NSMutableString* injectJs = [NSMutableString new];
    // 如果 external 对象存在，则清空它
    [injectJs appendString:@"if(typeof window.external != 'object'){window['external'] = {};};\n"];
    
    for(NSString* moduleName in moduleMap){
        
        if([moduleName isEqualToString:@"Base"]){
            // 单独注入 external 的成员方法（即 WKBridge 的成员方法）
            enumerateMethodNames([WKBridge class], filters,^(NSString *methodName) {
                NSLog(@" method name:%@",methodName);
                methodName = [methodName stringByReplacingOccurrencesOfString:@":" withString:@""];
                
                [webView.configuration.userContentController addScriptMessageHandler:handler name:methodName];
                
                [injectJs appendFormat:@"window.external['%@']= function %@(data) { window.webkit.messageHandlers.%@.postMessage(data);};\n",methodName,methodName,methodName];
            });

        }else{
            // 循环注入 external.<模块名称> 的成员方法
            NSString* className = moduleMap[moduleName];
            NSLog(@"Add Message for class:%@",className);
            Class clazz = NSClassFromString(className);
            enumerateMethodNames(clazz, filters,^(NSString *methodName) {
                NSLog(@" method name:%@",methodName);
                methodName = [methodName stringByReplacingOccurrencesOfString:@":" withString:@""];
                NSString* msgName = [NSString stringWithFormat:@"%@$%@",moduleName,methodName];
                [webView.configuration.userContentController addScriptMessageHandler:handler name:msgName];
                
                [injectJs appendFormat:@"window.external['%@']={};\n",moduleName];
                
                [injectJs appendFormat:@"window.external.%@['%@']= function %@(data) { window.webkit.messageHandlers.%@.postMessage(data);};\n",moduleName,methodName,methodName,msgName];
            });
        }
    }
    
    NSLog(@"inject method:%@",injectJs);

    [webView evaluateJavaScript:injectJs completionHandler:^(id result, NSError *err) {
        completion(result,err);
    }];
}


