//
//  carListModel.h
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/6.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dealerModel.h"

@interface CarListModel : NSObject

@property(nonatomic,strong)DealerModel *dealerModel;
@property(nonatomic,strong)NSString *specidString;
@property(nonatomic,strong)NSString *specnameString;
@property(nonatomic,strong)NSString *specpicString;
@property(nonatomic,strong)NSString *seriesidString;
@property(nonatomic,strong)NSString *seriesnameString;
@property(nonatomic,strong)NSString *inventorystateString;
@property(nonatomic,strong)NSString *styledinventorystateString;
@property(nonatomic,strong)NSString *dealerpriceString;
@property(nonatomic,strong)NSString *fctpriceString;
@property(nonatomic,strong)NSString *specstatusString;
@property(nonatomic,strong)NSString *articletypetring;
@property(nonatomic,strong)NSString *articleidString;
@property(nonatomic,strong)NSString *ordercountString;
@property(nonatomic,strong)NSString *enddateString;
@property(nonatomic,strong)NSString *assellphoneString;
@property(nonatomic,strong)NSString *orderrangetitleString;
@property(nonatomic,strong)NSString *orderrangeString;

@end
