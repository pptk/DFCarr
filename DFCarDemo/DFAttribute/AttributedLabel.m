//
//  AttributedLabel.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/6.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "AttributedLabel.h"

@interface AttributedLabel()
{
    
}
@property(nonatomic,retain)NSMutableAttributedString *attString;
@property(nonatomic,assign)CGFloat fontSize;

@end

@implementation AttributedLabel
@synthesize attString = _attString;
@synthesize fontSize = _fontSize;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = _attString;
    
//    UIFont *font = [UIFont systemFontOfSize:20];
//    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    textLayer.font = fontRef;
    textLayer.fontSize = 20.0f;
    textLayer.font = (__bridge CFTypeRef)(@"HiraKakuProN-W3");
    
    textLayer.contentsScale = 2;//确保不变模糊
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:textLayer];
}

-(void)setText:(NSString *)text{
    [super setText:text];
    if(text == nil){
        self.attString = nil;
    }else{
        self.attString = [[NSMutableAttributedString alloc]initWithString:text];
    }
}


-(void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if(location <0 || location>self.text.length-1 || length+location >self.text.length){
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(location, length)];
}

-(void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if(location <0 || location>self.text.length-1 || length+location>self.text.length){
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL)) range:NSMakeRange(location, length)];
}
-(void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if(location < 0 || location>self.text.length-1 || length+location >self.text.length){
        return;
    }
    [_attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:style] range:NSMakeRange(location, length)];
}

@end
