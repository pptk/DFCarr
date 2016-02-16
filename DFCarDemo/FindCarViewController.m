//
//  FindCarViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "FindCarViewController.h"
#import "Macro.h"
#import "AFNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface FindCarViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *carAsy;
    UIView *rightView;
    BOOL isShow;
    UIBarButtonItem *showDown;
    NSString *selectedID;
    UITableView *rightTableView;
    NSArray *rightAsy;
    NSString *msID;
}
@end

@implementation FindCarViewController
@synthesize tableView = _tableView;



-(void)viewDidLoad{
    [super viewDidLoad];
    isShow = YES;
    rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 200, SCREEN_HEIGHT-102)];
    rightView.backgroundColor = UIColorFromRGBA(0xeeeeee, 0.8);
    [self.view addSubview:rightView];
    
    [self getDataFromServer];
//    [self getDataFromUserDefault];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.navigationItem.title = @"找车";
    
    msID = [[NSString alloc]init];
    
}
#pragma mark get data from user
-(void)getDataFromUserDefault{
    NSDictionary *dic = [USER_DEFAULT objectForKey:@"car"];
    NSDictionary *result = [dic objectForKey:@"result"];
    carAsy = [result objectForKey:@"brandlist"];
    [self.tableView reloadData];
    //    NSLog(@" %@ ",carAsy);
}
#pragma mark get data from server
-(void)getDataFromServer{
    if([USER_DEFAULT objectForKey:@"car"] == nil){
        [AFNetworkTool JSONDataWithUrl:[[NSString stringWithFormat:@"%@",@"http://baojiac.qichecdn.com/v3.5.5/cars/brands-a2-pm1-v3.5.5-ts0.html"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] success:^(id json) {
            NSDictionary *dic = (NSDictionary *)json;
            NSDictionary *result = [dic objectForKey:@"result"];
            carAsy = [result objectForKey:@"brandlist"];
            [self.tableView reloadData];
            
//            [USER_DEFAULT setObject:dic forKey:@"car"];//存入
            
        } fail:^{
            NSLog(@"获取失败了。");
        }];
    }
}

#pragma mark delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == _tableView){
        return carAsy.count;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *asy = [carAsy[section] objectForKey:@"list"];
    if(tableView == _tableView){
        return asy.count;
    }else{
        return rightAsy.count;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == _tableView){
        NSString *title = [carAsy[section] objectForKey:@"letter"];
        return title;
    }else{
        return nil;
    }
}

//
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *asy = [[NSMutableArray alloc]init];
    for (int i = 0;i<carAsy.count;i++) {
        NSString *title = [carAsy[i] objectForKey:@"letter"];
        [asy addObject:title];
    }
//    
//    if(tableView == self.searchDisplayController.searchResultsTableView){
//        return nil;
//    }
    return asy;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tableView){
        return 50;
    }else{
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if(tableView == _tableView){
        NSArray *carAsyy = [carAsy[indexPath.section] objectForKey:@"list"];//根据section获得不同的汽车品牌
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[carAsyy[indexPath.row] objectForKey:@"imgurl"]] placeholderImage:[UIImage imageNamed:@"selected_yes.png"]];
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 200, 50)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [carAsyy[indexPath.row] objectForKey:@"name"];
        [cell.contentView addSubview:label];
    }
    if(tableView == rightTableView){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 100, 80)];
        [imageView sd_setImageWithURL:[rightAsy[indexPath.row] objectForKey:@"imgurl"] placeholderImage:[UIImage imageNamed:@"selected_yes.png"]];
        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 100, 25)];
        nameLabel.text = [rightAsy[indexPath.row] objectForKey:@"name"];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 40, 100, 25)];
        levelLabel.text = [rightAsy[indexPath.row] objectForKey:@"levelname"];
        [cell.contentView addSubview:levelLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 70, 150, 25)];
        priceLabel.text = [rightAsy[indexPath.row] objectForKey:@"price"];
        [cell.contentView addSubview:priceLabel];
        
    }
    
    return cell;
}


-(void)rightView{
    if(isShow == NO){//如果已经显示了、就关闭。并且移除掉uiBarButtonItem
        [UIView animateWithDuration:0.2 animations:^{
            showDown.title = @"";
            rightView.frame = CGRectMake(SCREEN_WIDTH, 0, 250, SCREEN_HEIGHT-112);
        }];
        isShow = YES;
    }
}
#pragma mark 没有显示的时候。显示出来。
-(void)rightViewShow{
    if(isShow){//没有显示的时候
         showDown = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(rightView)];
        self.navigationItem.rightBarButtonItem = showDown;
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.view sendSubviewToBack:_tableView];
            rightView.frame = CGRectMake(SCREEN_WIDTH-250, 0, 250, SCREEN_HEIGHT-112);
            //分割线。
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, SCREEN_HEIGHT-112)];
            view.backgroundColor = UIColorFromRGB(0x0099ff);
            [rightView addSubview:view];
            
            //右侧应该显示的数据。如果已经显示的时候、右侧应该显示什么
            rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(2, 0, 250, SCREEN_HEIGHT-112) style:UITableViewStylePlain];
//            rightTableView.tableFooterView =
            [rightView addSubview:rightTableView];
        }];
        isShow = NO;
    }

    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    
    [rightTableView addHeaderWithTarget:self action:@selector(getRightDataFromServer)];//增加顶部刷新。
    [rightTableView headerBeginRefreshing];
}
#pragma mark 获取数据、得到
-(void)getRightDataFromServer{
    NSString *url = [[NSString alloc]initWithFormat:@"http://app.api.autohome.com.cn/autov3.2/cars/seriesprice-a2-pm1-v3.2.0-b%@-t1.html",msID];
    [AFNetworkTool JSONDataWithUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *fctlist = [result objectForKey:@"fctlist"];
        NSArray *serieslist = [fctlist[0] objectForKey:@"serieslist"];
        rightAsy = [[NSArray alloc]initWithArray:serieslist];
        
        [rightTableView headerEndRefreshing];//结束刷新。
        [rightTableView reloadData];
    } fail:^{
        NSLog(@"没有获取到数据。");
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == tableView){
        NSArray *carAsyy = [carAsy[indexPath.section] objectForKey:@"list"];
        msID = [carAsyy[indexPath.row] objectForKey:@"id"];//找到选中该条的ID
        [self rightViewShow];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if(tableView == rightTableView){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
