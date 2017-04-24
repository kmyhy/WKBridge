//
//  NSObjectExtension.m
//  Youxin
//
//  Created by yanghongyan on 16/7/19.
//  Copyright (c) 2016年 EPIC. All rights reserved.
//

#import "NSObjectExtension.h"

@implementation NSObject(Extension)
-(void)callSelector:(NSString*)selStr target:(id)target withObject:(id)object{
    
    SEL sel=NSSelectorFromString(selStr);
    
    NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:sel]];
    
    [invoc setSelector:sel];
    [invoc setTarget:target];
    
    if(object!=nil){
        [invoc setArgument:&object atIndex:2];//"Indices 0 and 1 indicate the hidden arguments self and _cmd"
    }
    
    [invoc performSelector:@selector(invoke) withObject:nil];
}

@end
