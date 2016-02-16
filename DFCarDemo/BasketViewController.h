//
//  BasketViewController.h
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/16.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BasketViewController : BaseViewController

- (IBAction)vcBack:(id)sender;//返回
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSArray *basketAsy;

@end
