//
//  ConcatenateController.h
//  WKBridge
//
//  Created by qq on 2017/4/26.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKBridge.h"

@interface ConcatenateController : UIViewController<WKBridgeDelegate>

@property(copy,nonatomic)NSString* string1;
@property(copy,nonatomic)NSString* string2;
@property(copy,nonatomic)NSString* callback;
@property(weak,nonatomic)WKBridge* bridge;

@end
