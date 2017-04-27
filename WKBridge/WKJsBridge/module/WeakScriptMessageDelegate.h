//
//  WeakScriptMessageDelegate.h
//  Client
//
//  Created by qq on 2017/4/27.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
