//
//  WKAlertBridge.h
//  WKBridge
//
//  Created by qq on 2017/4/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBridge.h"

@interface WKAlertBridge : WKBridge

-(void)alert:(NSArray* )data;       // 2. 字典(JSON 对象）参数

@end
