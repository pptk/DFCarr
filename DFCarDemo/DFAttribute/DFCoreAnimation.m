//
//  ThrowLineTool.m
//  CAKeyframeAnimationDemo
//
//  Created by ianc-ios on 15/11/13.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "DFCoreAnimation.h"

static DFCoreAnimation *s_sharedInstance = nil;

@implementation DFCoreAnimation

//new 一个单例
+(DFCoreAnimation *)sharedTool{
    if(!s_sharedInstance){
        s_sharedInstance = [[[self class] alloc]init];
    }
    return s_sharedInstance;
}

-(void)throwObject:(UIView *)obj from:(CGPoint)start to:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration{
    
    self.showInView = obj;
    
    //弧形
    CGMutablePathRef path = CGPathCreateMutable();
    //计算弧形顶点的位置。
    CGFloat cpx = (start.x + end.x)/2;
    CGFloat cpy = -height;
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, end.x, end.y);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CFRelease(path);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.toValue = [NSNumber numberWithFloat:(CGFloat)((arc4random() % 4)+4)/10.0];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.delegate = self;
    groupAnimation.repeatCount = 1;
    groupAnimation.duration = duration;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.animations = @[scaleAnimation,animation];
    [obj.layer addAnimation:groupAnimation forKey:@"positionscale"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(animationDidFinish)]){
        [self.delegate performSelector:@selector(animationDidFinish) withObject:nil];
    }
    self.showInView = nil;
}


-(void)moveLayer:(UIView *)obj fromValue:(CGPoint)fromValue toValue:(CGPoint)toValue duration:(CGFloat)duration repeatCount:(int)MaxRepeatCount autoreverses:(BOOL)isBack{
    
    self.showInView = obj;
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:fromValue];
    moveAnimation.toValue = [NSValue valueWithCGPoint:toValue];
    moveAnimation.autoreverses = isBack;
    moveAnimation.repeatCount = MaxRepeatCount;//重复次数
    moveAnimation.duration = duration;
    
    [obj.layer addAnimation:moveAnimation forKey:@"position"];
}

-(void)scaleLayer:(UIView *)obj fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration repeatCount:(int)MAXRepeatCount autoreverses:(BOOL)isBack{
    
    self.showInView = obj;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:fromValue];//原大小
    scaleAnimation.toValue = [NSNumber numberWithFloat:toValue];//放大
    scaleAnimation.autoreverses = isBack;//是否缩回去.动画原路返回。
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.repeatCount = MAXRepeatCount;
    scaleAnimation.duration = duration;
    
    [obj.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
}

-(void)rotateLayer:(UIView *)obj fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue duration:(CGFloat)duration repeatCount:(int)MAXRepeatCount autoreverses:(BOOL)isBack{
    
    self.showInView = obj;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    rotateAnimation.toValue = [NSNumber numberWithFloat:toValue];
    rotateAnimation.autoreverses = isBack;
    rotateAnimation.repeatCount = MAXRepeatCount;
    rotateAnimation.duration = duration;
    
    [obj.layer addAnimation:rotateAnimation forKey:@"transform.rotation.x"];
}
@end
