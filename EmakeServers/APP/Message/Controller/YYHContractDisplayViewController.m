//
//  YYHContractDisplayViewController.m
//  EmakeServers
//
//  Created by 谷伟 on 2018/3/20.
//  Copyright © 2018年 谷伟. All rights reserved.
//

#import "YYHContractDisplayViewController.h"
#import <WebKit/WebKit.h>
#import "Header.h"
#import "YHChatContractModel.h"
@interface YYHContractDisplayViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation YYHContractDisplayViewController
- (WKWebView *)webView{
    if (!_webView) {
        WKWebView *wk =  [[WKWebView alloc] init];
        wk.navigationDelegate = self;
        wk.UIDelegate = self;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ContractURL]];
        [wk loadRequest:urlRequest];
        self.webView = wk;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self.contractType isEqualToString:@"0"]) {
        self.title =@"买卖合同";
    }else if ([self.contractType isEqualToString:@"1"]) {
        self.title =@"完整合同";
    }else if ([self.contractType isEqualToString:@"2"]) {
        self.title =@"技术协议";
    }
    [self configUI];
    [self configWebViewProgress];
}
- (void)configUI{
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(TOP_BAR_HEIGHT);
        make.left.mas_equalTo(WidthRate(10));
        make.right.mas_equalTo(WidthRate(-10));
        make.bottom.mas_equalTo(0);
    }];
    
}
- (void)configWebViewProgress {
    
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - 2.0f, navigationBarBounds.size.width, 2.0);
    _progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WKNavigationDelegate &  WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        if (self.sendDataStr.length>0) {
            YHChatContractModel *model = [YHChatContractModel mj_objectWithKeyValues:self.sendDataStr];
            model.Text = @"您有技术协议需要确认！";
            if([message isEqualToString:@"提交成功"]){
                if (self.block) {
                    self.block([model mj_JSONString]);
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    completionHandler();
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
