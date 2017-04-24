//
//  WKDelegate.m
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "WKBridge.h"
#import "UIViewControllerExtension.h"

@implementation WKBridge
// 以下 4 个方法分别演示了 JS 的 4 种传参方式：无参数、字典参数、字符串参数、数组参数
-(void)navBack{ // 1. 无参数，示例：external.navBack();
    if(_wkController!=nil && _wkController.navigationController!=nil){
        [_wkController navBack];
    }
}
-(void)alert:(NSArray* )data{ // 2. 字典(JSON 对象）参数，示例：external.alert({title:'123',msg:'abc'});
    if(_wkController!=nil){
    UIAlertController* ac=[UIAlertController alertControllerWithTitle:data[0][@"title"] message:data[0][@"msg"] preferredStyle:UIAlertControllerStyleAlert];
    
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_wkController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
        [_wkController presentViewController:ac animated:YES completion:nil];
    }
}
-(void)log:(NSArray* )data{ // 3. 字符串参数，示例：external.log('ddddd');
    NSLog(@"%@",data[0]);
}
-(void)sum:(NSArray*)data{ // 4. 数组参数，示例：external.sum([3,5,9]);
    double total=0;
    if([data[0] isKindOfClass:[NSArray class]]){
        NSArray* array = data[0];
        for(int i=0;i<array.count;i++){
            NSNumber* number= array[i];
            total+=number.doubleValue;
        }
        [self alert:@[@{@"title":@"总数为：",@"msg":[NSString stringWithFormat:@"%f",total]}]];
    }
    
}
/////////////////////////////////////////////////////
@end
