//
//  WKController.m
//  Client
//
//  Created by qq on 2017/3/20.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "WKController.h"
#import "WKBridge.h"
#import "WKJsBridge.h"
#import <WebKit/WebKit.h>
#import "dimensions.h"
//#import <API/API.h>
#import "NSString+Add.h"
#import "NSObjectExtension.h"
#import "WKWebView+JS.h"
#import "WKNavigationBridge.h"
#import "WKLogBridge.h"
#import "WKAlertBridge.h"

@interface WKController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView* webView;
@property(nonatomic,strong)UIProgressView* progressView;

@property(nonatomic,copy,readonly)NSDictionary* moduleMaps;
@property(nonatomic,strong)NSMutableDictionary* modules;

// js 注入是否成功
@property(nonatomic,assign)BOOL injectJsSuccess;

@end

@implementation WKController

- (void)viewDidLoad {
    [super viewDidLoad];

    _moduleMaps = @{
                    @"Base":@"WKBridge",
                    @"Nav":@"WKNavigationBridge",
                    @"Alert":@"WKAlertBridge",
                    @"Log":@"WKLogBridge"
                    };
    
    [self initWebView];// 添加 webview
    [self initProgressView];// 添加进度条
    
    // 加载 URL
    if(self.url != nil){

        NSURLRequest* req=[[NSURLRequest alloc]initWithURL:self.url];

//        [self setCookieToURL:self.url cookieName:@"token" cookieValue:[[AccountAdditionalModel currentAccount] getUserToken]];
        [self.webView loadRequest:req];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Private
-(void)initWebView{
    
    WKWebViewConfiguration* conf=[WKWebViewConfiguration new];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:conf];

    [self.view addSubview:self.webView];
    
    self.webView.navigationDelegate = self;
    
    self.webView.UIDelegate = self;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)initProgressView{
    CGFloat top = 1/SCREEN_SCALE;
    
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, top, self.view.bounds.size.width, 0)];
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];
}

-(void)injectJsModules:(NSDictionary<NSString*,NSString*>*) map{
    if(self.injectJsSuccess==NO){
        
        __weak __typeof(self) weakSelf = self;
        NSArray* filter = @[@"init",@"wkController",@"setWkController:"];// MARK: 过滤掉 BaseBrdige 中的默认构造方法和属性的 getter/setter 方法
        addMessageToWebView(map, filter, self.webView, self, ^(id result, NSError *error) {
            if(error==nil){
                weakSelf.injectJsSuccess = YES;
                [weakSelf.webView evaluateJavaScript:@"iOSReady()" completionHandler:nil];
            }else{
                weakSelf.injectJsSuccess = NO;
            }
        });
    }
}
-(BOOL)registerModules:(NSArray<NSString*>*)moduels{
    self.modules = [NSMutableDictionary new];
    for(NSString* modname in moduels){
        NSString* className = self.moduleMaps[modname];
        if(className!=nil){
            id bridge = [[NSClassFromString(className) alloc] init];
            if([bridge isKindOfClass:[WKBridge class]]){
                ((WKBridge*)bridge).wkController = self;
                _modules[modname] = bridge;
            }
        }
    }
    return YES;
}
-(void)setCookieToURL:(NSURL*)url cookieName:(NSString*)cookieName cookieValue:(NSString*)cookieValue{
    NSMutableDictionary* dic=[[NSDictionary dictionaryWithObjectsAndKeys:
                       cookieName, NSHTTPCookieName,
                       cookieValue, NSHTTPCookieValue,
                       @"/", NSHTTPCookiePath,
                       @"1.0", NSHTTPCookieVersion,
                       nil] mutableCopy];
    
    if (url.host) {
        dic[NSHTTPCookieDomain]=url.host;
        dic[NSHTTPCookieOriginURL]=url.host;
    }
    
    NSHTTPCookie* cookie = [[NSHTTPCookie alloc]initWithProperties:dic];
    
    if(cookie){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

// MARK: extension - WKUIDelegate
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController* ac=[UIAlertController alertControllerWithTitle:self.webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];

    [self presentViewController:ac animated:YES completion:nil];
    
}
// MARK: extension - WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"******收到 JS 消息：%@，内容：%@",message.name,message.body);
    
    NSString* methodName = message.name;
    
    id bridge = nil;
    if([methodName containsString:@"$"]){// 如果消息名中包含了 $，则需要取出模块名称
        NSArray<NSString*>* components = [methodName componentsSeparatedByString:@"$"];
        if(components.count>1){
            NSString* moduleName = components[0];
            methodName = components[1];
            bridge = _modules[moduleName];
        }
        
    }else{
        bridge = _modules[@"Base"];
    }
    
    if(bridge != nil){
        if(message.body == nil){// 方法无参数
            NSLog(@"message's body is nil");
            SEL sel= NSSelectorFromString(methodName);
            
            if([bridge respondsToSelector:sel]){
                
                [self callSelector:methodName target:bridge withObject:nil];
            }else{
                NSLog(@"%@方法未找到！",methodName);
            }
        }else{ // 方法有 1 个参数
            SEL sel= NSSelectorFromString([methodName add:@":"]);
             if([bridge respondsToSelector:sel]){
                 [self callSelector:[methodName add:@":"] target:bridge withObject:@[message.body]];
             }else{
                 NSLog(@"%@方法未找到！",[methodName add:@":"]);
             }
        }
    }else{
        NSLog(@"WKBridge 未初始化");
    }
}
// MARK: extension - WKNavigationDelegate
// 页面加载完成
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
  
//    [self.webView callJsWithFunName:@"alert" param:@"abcd"];//Just for test
    
    // 如果 native_modules() js 函数未定义，则报一个“A JavaScript exception occurred”错误。
    __weak __typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"native_modules()" completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                NSString* resultString = [NSString stringWithFormat:@"%@", result];
                
//                NSLog(@"js 返回 %@",resultString);
                NSArray<NSString*> *result = [resultString componentsSeparatedByString:@","];
                
                // 模块-类名映射
                NSMutableDictionary<NSString*,NSString*> *map = [NSMutableDictionary<NSString*,NSString*> new];
                
                map[@"Base"]=@"WKBridge";// 默认注入 Base 模块
                for(NSString* module in result){
                    NSString* class = weakSelf.moduleMaps[module];
                    
                    if(class){
                        map[module]=class;
                    }
                }
                if(map != nil && map.count > 0){
                    // 注册本地(原生)模块
                    if([self registerModules:map.allKeys]){
                        // 注入 JS 模块
                        [self injectJsModules:map];
                    }else{
                        NSLog(@"注册本地模块失败！");
                    }
                }
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
}
// 页面加载失败
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载失败：%@",error.debugDescription);
}

// 页面加载失败
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载失败：%@",error.debugDescription);
}

// MARK: - KVO 跟踪 WKWebView 加载进度

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"estimatedProgress"]){
        
        self.progressView.progress = self.webView.estimatedProgress;
        
        if(self.webView.estimatedProgress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
            });
        }else if(self.progressView.hidden == YES){
            self.progressView.hidden = NO;
        }
    }
}
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
