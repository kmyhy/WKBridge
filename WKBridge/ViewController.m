//
//  ViewController.m
//  WKBridge
//
//  Created by qq on 2017/4/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "ViewController.h"
#import "WKController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadHTML:(id)sender {
    WKController* vc = [[WKController alloc]init];
    
    vc.url = [[NSBundle mainBundle]URLForResource:@"h5.html" withExtension:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
