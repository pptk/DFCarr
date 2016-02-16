//
//  ThrowLineTool.h
//  CAKeyframeAnimationDemo
//
//  Created by ianc-ios on 15/11/13.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//声协议。方便引用。
@protocol ThrowLineToolDelegate;




@interface DFCoreAnimation : NSObject

@property(nonatomic,assign)id<ThrowLineToolDelegate> delegate;
@property(nonatomic,retain)UIView *showInView;

+(DFCoreAnimation *)sharedTool;
//抛物线
-(void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration;
//缩放
-(void)scaleLayer:(UIView *)obj fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration repeatCount:(int)MAXRepeatCount autoreverses:(BOOL)isBack;
//移动
-(void)moveLayer:(UIView *)obj fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)
duration repeatCount:(int)MaxRepeatCount autoreverses:(BOOL)isBack;

//旋转
-(void)rotateLayer:(UIView *)obj fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration repeatCount:(int)MAXRepeatCount autoreverses:(BOOL)isBack;


@end




//回调方法
@protocol ThrowLineToolDelegate <NSObject>

-(void)animationDidFinish;

@end