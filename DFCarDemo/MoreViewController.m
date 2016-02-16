//
//  MoreViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "MoreViewController.h"
#import "DFCoreAnimation.h"
#import "Macro.h"

@implementation MoreViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSLog(@"----");
    //move
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    view.backgroundColor = [UIColor blackColor];
    DFCoreAnimation *dfCA = [DFCoreAnimation sharedTool];
    [dfCA moveLayer:view fromValue:view.center toValue:CGPointMake(200, 200) duration:1 repeatCount:100 autoreverses:YES];
    
    [self.view addSubview:view];
    
    //scale
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    view2.backgroundColor = [UIColor blueColor];
    [dfCA scaleLayer:view2 fromValue:1 toValue:2 duration:2 repeatCount:100 autoreverses:YES];
    [self.view addSubview:view2];
    
    //rotate
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(200, 250, 50, 50)];
    view3.backgroundColor = [UIColor grayColor];
    [dfCA rotateLayer:view3 fromValue:0 toValue:0.5*M_PI duration:1 repeatCount:100 autoreverses:YES];
    
    [dfCA moveLayer:view3 fromValue:view3.center toValue:CGPointMake(50, 50) duration:1 repeatCount:100 autoreverses:YES];
    [dfCA scaleLayer:view3 fromValue:1 toValue:2 duration:1 repeatCount:100 autoreverses:YES];//同时调用多个。就可以执行组合动画。
    [self.view addSubview:view3];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, SCREEN_HEIGHT/2 - 64, 200, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"DF~~~";
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-138, 100, 30)];
    label1.text = @"彭雄辉";
    [self.view addSubview:label1];
    
}


@end
