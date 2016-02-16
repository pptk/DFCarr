//
//  DetailViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/16.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "DetailViewController.h"
#import "Macro.h"

@interface DetailViewController ()<UIWebViewDelegate>
{
    UIView *loadView;
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_detailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    self.navigationItem.title = @"文章详情";
}
#pragma mark 开始加载
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self startRefresh];
}
#pragma mark 加载成功
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    loadView.hidden = YES;
    [activityIndicatorView stopAnimating];
}

#pragma mark 加载失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(void)startRefresh{
    NSLog(@"yes");
    loadView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2-50, 100, 100)];
    loadView.backgroundColor = UIColorFromRGBA(0x999999,0.8);
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(35, 25, 30, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 100, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"正在加载...";
    label.textColor = UIColorFromRGB(0x333333);
    loadView.layer.cornerRadius = 6;
    loadView.layer.masksToBounds = YES;
    
    [activityIndicatorView startAnimating];
    [loadView addSubview:label];
    [loadView addSubview:activityIndicatorView];//加载到view里面。
    [self.view addSubview:loadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
