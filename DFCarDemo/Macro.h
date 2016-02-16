//
//  Macro.h
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <UIKit/UIKit.h>


#define HAVE_BEEN_USED @"bool.havebeenused"//是否第一次登陆


#define SYSTEM_BUNDLE_VERSION @"CFBundleVersion"
#define SYSTEM_SHORT_VERSION @"CFBundleShortVersionString"
#define LASTVERSION @"string.lastversion" //上次使用的版本号，用来判断是否是第一次使用更新后的软件 与当前版本号比较
//颜色
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue,1.0)
#define UIColorFromRGBA(rgbValue,alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00)>> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//使得NSLog显示行数
#define NSLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)