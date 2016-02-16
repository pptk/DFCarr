//
//  PaperViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "PaperViewController.h"
#import "Macro.h"
#import "AFNetworkTool.h"
#import "NewModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
//#import "CoreLaunchPlus.h"

@interface PaperViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *leftDataArray;
    NSMutableArray *rightDataArray;
    long leftSelectedIndex;
    long PageCount;
}
@end

@implementation PaperViewController
@synthesize leftTableView = _leftTableView;
@synthesize rightTableView = _rightTableView;

-(void)viewDidLoad{
    [super viewDidLoad];
//    [CoreLaunchPlus animWithWindow:window image:nil];
    [self CreateNav];//set Navigation
    [self setLeftData];
    [self CreateTableView];//一切行为的入口都在TableView中。
}
-(void)CreateNav{
    self.navigationItem.title = @"文章";
}
-(void)setLeftData{
    //left data
    leftDataArray = @[@"最新",@"视频",@"新闻",@"评测",@"导购",@"行情",@"用车",@"技术",@"文化",@"改装",@"游记",@"原创",@"说客"];
    leftSelectedIndex = 0;//-----------------存到userDefaults。每次从那里获取。就可以保存了。（这里记得要处理、假如上次退出是在12或者比较后面、要讲leftTableView上移。否则一进来看不到。）
    
}

-(void)CreateTableView{
    //left
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 0.01)];
    _leftTableView.tableHeaderView = view;
    _leftTableView.tableFooterView = view;
//    self.tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    //right
    _rightTableView.delegate =self;
    _rightTableView.dataSource = self;
    [_rightTableView addHeaderWithTarget:self action:@selector(headerRefering)];
    [_rightTableView headerBeginRefreshing];//刚进入的时候就刷新一次。
    [_rightTableView addFooterWithTarget:self action:@selector(footerRefering)];
    _rightTableView.tableFooterView = view;
    _rightTableView.tableHeaderView = view;
}
-(void)getDataFromServer:(long)index{
    if(!rightDataArray){
        rightDataArray = [NSMutableArray new];
    }else{
        [rightDataArray removeAllObjects];
    }
    NSString *url = [[NSString stringWithFormat:@"http://app.api.autohome.com.cn/autov3.2/news/newslist-a2-pm1-v3.2.0-c0-nt0-p%ld-s20-l0.html",index] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSDictionary *result = [dic objectForKey:@"result"];
//        NSDictionary *headlineinfo = [result objectForKey:@"headlineinfo"];//题头用的。
        NSArray *newslist = [result objectForKey:@"newslist"];
        for (int i = 0; i<newslist.count; i++) {
            NewModel *model = [[NewModel alloc]init];
            model.newsid = [newslist[i] objectForKey:@"id"];
            model.title = [newslist[i] objectForKey:@"title"];
            model.type = [newslist[i] objectForKey:@"type"];
            model.time = [newslist[i] objectForKey:@"time"];
            model.intacttime = [newslist[i] objectForKey:@"intacttime"];;
            model.indexdetail = [newslist[i] objectForKey:@"indexdetail"];;
            model.smallpic = [newslist[i] objectForKey:@"smallpic"];
            model.replycount = [newslist[i] objectForKey:@"replycount"];
            model.pagecount = [newslist[i] objectForKey:@"pagecount"];
            model.jumppage = [newslist[i] objectForKey:@"jumppage"];
            [rightDataArray addObject:model];
        }
        NSLog(@"------------right data count = %ld",rightDataArray.count);
        [_rightTableView reloadData];
        [self.rightTableView headerEndRefreshing];
    } fail:^{
        NSLog(@"请求失败");
    }];
    
}
#pragma mark 头部刷新事件
-(void)headerRefering{
    [self getDataFromServer:leftSelectedIndex];
    NSLog(@"头部刷新");
    PageCount = 10;
    
}
#pragma mark 底部刷新事件
-(void)footerRefering{
    if(PageCount < rightDataArray.count){
        PageCount = PageCount+10;
    }
    [self.rightTableView reloadData];
    [self.rightTableView footerEndRefreshing];
}

#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _leftTableView){
        return 13;
    }else{
        return PageCount;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTableView){
        return 50;
    }else{
        return 100;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTableView){
        static NSString *leftIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftIdentifier];
        if(cell == nil){//left cell
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftIdentifier];
        }else{
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if(indexPath.row == leftSelectedIndex){
            cell.backgroundColor = UIColorFromRGB(0xeeeeee);
        }else{
            cell.backgroundColor = [UIColor grayColor];
        }
        {//UILabel
            UILabel *classLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 90, 30)];
            classLabel.textAlignment = NSTextAlignmentCenter;
            classLabel.font = [UIFont systemFontOfSize:16];
            classLabel.textColor = [UIColor blackColor];
            classLabel.text = leftDataArray[indexPath.row];
            [cell.contentView addSubview:classLabel];
        }
        return cell;
    }else{//right cell
        static NSString *rightIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightIdentifier];
        
        if(cell == nil){//left cell
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightIdentifier];
        }else{
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        if(rightDataArray.count > 0){
            NewModel *model = rightDataArray[indexPath.row];
            //UIImage
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 100, 80)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.smallpic]] placeholderImage:[UIImage imageNamed:@"selected_no"]];
            //title
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(108, 10, 280-108, 50)];
            titleLabel.textAlignment = NSTextAlignmentNatural;
            titleLabel.text = model.title;
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.numberOfLines = 0;
            //time
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(108, 70, 100, 20)];
            timeLabel.text = model.time;
            timeLabel.font = [UIFont systemFontOfSize:14];
            timeLabel.textColor = UIColorFromRGB(0x555555);
            
            [cell.contentView addSubview:timeLabel];
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:imageView];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTableView){//did select left tableView
        leftSelectedIndex = indexPath.row;
        [_leftTableView reloadData];
        [_rightTableView headerBeginRefreshing];
    }else{//did select right tableView
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NewModel *model = rightDataArray[indexPath.row];
        NSString *detailUrl = [NSString stringWithFormat:@"http://sp.autohome.com.cn/news/news_V3_0.aspx?newsid=%@&pageIndex=%@&nolazyLoad=0&spmodel=0&showad=1",model.newsid,@"%d"];
        NSLog(@"detailUrl == %@",detailUrl);
        DetailViewController *detailVC = [[DetailViewController alloc]init];
        detailVC.detailUrl = detailUrl;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end
