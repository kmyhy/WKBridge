//
//  ConcatenateController.m
//  WKBridge
//
//  Created by qq on 2017/4/26.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "ConcatenateController.h"

@interface ConcatenateController ()
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;
@property (weak, nonatomic) IBOutlet UITextField *tfResult;

@end

@implementation ConcatenateController
- (IBAction)backAction:(id)sender {
    __weak __typeof(self) weakSelf= self;
    [self dismissViewControllerAnimated:YES completion:^{
        if(weakSelf.callback!=nil && weakSelf.tfResult.text!=nil){
            // 回调函数要求一个 JSON 字符串
            NSString* result = [NSString stringWithFormat:@"{'msg':'%@'}",weakSelf.tfResult.text];
            
            [weakSelf.bridge callbackJS:weakSelf.callback result:result];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _tf1.text= _string1;
    _tf2.text = _string2;
    
    _tfResult.text = [NSString stringWithFormat:@"%@%@",_string1,_string2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
