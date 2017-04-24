//
//  WKWebView+JS.h
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <WebKit/WebKit.h>


@interface WKWebView(JS)

-(void)callJsWithFunName:(NSString*)funame param:(id)param;//执行js方法
-(void)excuteJSWithObj:(NSString*)obj func:(NSString*)func;
@end
