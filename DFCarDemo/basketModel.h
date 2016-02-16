//
//  basketModel.h
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/16.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarListModel.h"

@interface basketModel : NSObject

@property(nonatomic,strong)CarListModel* carModel;
@property(nonatomic)NSInteger count;


@end
