//
//  WKController.h
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WKWebView+JS.h"

@interface WKController : UIViewController
@property(nonatomic,strong)NSURL* url;
@property(nonatomic,strong)WKWebView* webView;
@end
