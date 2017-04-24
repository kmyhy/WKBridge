//
//  WKAlertBridge.m
//  WKBridge
//
//  Created by qq on 2017/4/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "WKAlertBridge.h"

@implementation WKAlertBridge

-(void)alert:(NSArray* )data{ // 2. 字典(JSON 对象）参数，示例：external.alert({title:'123',msg:'abc'});
    [super alert:data];
}

@end
