//
//  UILabelCenterLine.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/6.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "UILabelCenterLine.h"

@implementation UILabelCenterLine

- (void)drawRect:(CGRect)rect
{
    // 调用super的目的，保留之前绘制的文字
    [super drawRect:rect];
    
    // 画线
    CGFloat x = 0;
    CGFloat y = rect.size.height * 0.5;
    CGFloat w = rect.size.width;
    CGFloat h = 1;
    UIRectFill(CGRectMake(x, y, w, h));
}

- (void)drawLine:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 1.起点
    CGFloat startX = 0;
    CGFloat startY = rect.size.height * 0.5;
    CGContextMoveToPoint(ctx, startX, startY);
    
    // 2.终点
    CGFloat endX = rect.size.width;
    CGFloat endY = startY;
    CGContextAddLineToPoint(ctx, endX, endY);
    
    // 3.绘图渲染
    CGContextStrokePath(ctx);
 
}
@end
