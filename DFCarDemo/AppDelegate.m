//
//  AppDelegate.m
//  DFCarDemo
//
//  Created by ianc-ios on 15/11/16.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "AppDelegate.h"
#import "Macro.h"
#import "PaperViewController.h"
#import "ForumViewController.h"
#import "FindCarViewController.h"
#import "PriceViewController.h"
#import "MoreViewController.h"
//#import "CoreLaunchPlus.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)CreateUserDefalut{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [USER_DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:HAVE_BEEN_USED];
    [USER_DEFAULT setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:SYSTEM_BUNDLE_VERSION] forKey:LASTVERSION];
    //    [USER_DEFAULT]
    
    [USER_DEFAULT synchronize];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if(![USER_DEFAULT boolForKey:HAVE_BEEN_USED]){
        NSLog(@"第一次使用本软件");
        [self CreateUserDefalut];
    }
    
    UITabBarController *tb = [[UITabBarController alloc]init];
    //文章
    PaperViewController *pageVC = [[PaperViewController alloc]init];
    pageVC.tabBarItem.title = @"文章";
    pageVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"selected_no"] toSize:CGSizeMake(25,25)];
    pageVC.tabBarItem.selectedImage = [self reSizeImage:[UIImage imageNamed:@"selected_yes"] toSize:CGSizeMake(25, 25)];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:pageVC];
    
    //论坛
    ForumViewController *forumVC = [[ForumViewController alloc]init];
    forumVC.tabBarItem.title =@"论坛";
    forumVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"selected_no"] toSize:CGSizeMake(25, 25)];
    forumVC.tabBarItem.selectedImage = [self reSizeImage:[UIImage imageNamed:@"selected_yes"] toSize:CGSizeMake(25, 25)];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:forumVC];
    
    //找车
    FindCarViewController *findVC = [[FindCarViewController alloc]init];
    findVC.tabBarItem.title = @"找车";
    findVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"selected_no"] toSize:CGSizeMake(25, 25)];
    findVC.tabBarItem.selectedImage = [self reSizeImage:[UIImage imageNamed:@"selected_yes"] toSize:CGSizeMake(25, 25)];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:findVC];
    
    //报价
    PriceViewController *priceVC = [[PriceViewController alloc]init];
    priceVC.tabBarItem.title = @"降价";
    priceVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"selected_no"] toSize:CGSizeMake(25, 25)];
    priceVC.tabBarItem.selectedImage = [self reSizeImage:[UIImage imageNamed:@"selected_yes"] toSize:CGSizeMake(25, 25)];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:priceVC];
    
    //更多
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    moreVC.tabBarItem.title = @"更多";
    moreVC.tabBarItem.image = [self reSizeImage:[UIImage imageNamed:@"selected_no"] toSize:CGSizeMake(25, 25)];
    moreVC.tabBarItem.selectedImage = [self reSizeImage:[UIImage imageNamed:@"selected_yes"] toSize:CGSizeMake(25, 25)];
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:moreVC];
    
    tb.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    tb.selectedIndex = 3;
    
    self.window.rootViewController = tb;
    [self.window makeKeyAndVisible];
    
    return YES;
}

//设定UIImageView大小/重画。
-(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //去掉UITableBar自带的反色效果！
    reSizeImage = [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return reSizeImage;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
