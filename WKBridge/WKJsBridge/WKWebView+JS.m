//
//  WKWebView+JS.m
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "WKWebView+JS.h"
#import "func.h"

@implementation WKWebView(JS)

-(void)callJsWithFunName:(NSString*)funname param:(id)param{
    
    [self excuteJSWithObj:@"window" func:makeJsCallString(funname, param)];
    
}

-(void)excuteJSWithObj:(NSString*)obj func:(NSString*)func{
    
    NSString* callStr=func;
    
    if(obj!=nil){
        callStr = [NSString stringWithFormat:@"%@.%@",obj,func];
    }
    
    NSLog(@"call js:%@",callStr);
    [self evaluateJavaScript:callStr completionHandler:nil];
}

@end
