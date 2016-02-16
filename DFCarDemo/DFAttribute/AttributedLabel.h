//
//  AttributedLabel.h
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/6.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//


//字不同颜色

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface AttributedLabel : UILabel

//设置某段字的颜色
-(void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;
//设置某段字的字体
-(void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;
//设置某段字的风格
-(void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;


@end
