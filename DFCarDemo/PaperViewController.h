//
//  PaperViewController.h
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PaperViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end
