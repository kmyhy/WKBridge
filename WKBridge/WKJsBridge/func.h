//
//  func.h
//  Client
//
//  Created by qq on 2016/12/5.
//  Copyright © 2016年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSDictionary -> NSString
NSString* dic2str(NSDictionary<NSString*,id> *d);
// 拼接 js 函数名 和 参数
NSString* makeJsCallString(NSString* funname,id params);







