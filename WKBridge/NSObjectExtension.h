//
//  NSObjectExtension.h
//  Youxin
//
//  Created by yanghongyan on 16/7/19.
//  Copyright (c) 2016年 EPIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Extension)
-(void)callSelector:(NSString*)selStr target:(id)target withObject:(id)object;
@end
