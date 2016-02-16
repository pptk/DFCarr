//
//  ForumViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "ForumViewController.h"
#import "MJRefresh.h"
#import "AFNetworkTool.h"
#import "ForumModel.h"
#import "Macro.h"
#import "UIImageView+WebCache.m"
#import "ForumWebView.h"

@interface ForumViewController()<UITableViewDataSource,UITableViewDelegate>
{
    int pageCount;
    NSMutableArray *forumArray;
    CGFloat width;
}
@end

@implementation ForumViewController
@synthesize forumTableView = _forumTableView;

-(void)viewDidLoad{
    [super viewDidLoad];
    [self CreateTableView];
    [self CreateNav];
    
}
#pragma mark CreateNav
-(void)CreateNav{
    self.navigationItem.title = @"论坛";
    width = [UIScreen mainScreen].bounds.size.width;
}
-(void)CreateTableView{
    _forumTableView.delegate = self;
    _forumTableView.dataSource = self;
    pageCount = 1;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 0.01)];
    _forumTableView.tableHeaderView = view;
    _forumTableView.tableFooterView = view;

    
    
    [_forumTableView addHeaderWithTarget:self action:@selector(getDataFromServer)];
    [_forumTableView headerBeginRefreshing];//第一次进入的时候直接刷新。
    [_forumTableView addFooterWithTarget:self action:@selector(getNextPage:)];
}
#pragma mark -下拉刷新事件-------刷新UITableView。同时获取数据。
-(void)getDataFromServer{
    //获取第一页。
    NSString *url = [@"http://app.api.autohome.com.cn/autov3.2//club/jinghuahome-a2-pm1-v3.2.0-p1-s20.html" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *forumList = [result objectForKey:@"list"];
        NSLog(@"forumlist %ld",forumList.count);
        //设置一个变量、来装下载到得数据。
        NSMutableArray *tempAsy = [[NSMutableArray alloc]init];
        for (int i = 0; i<forumList.count; i++) {
            ForumModel *model = [[ForumModel alloc]init];
            model.bbsId = [forumList[i] objectForKey:@"bbsid"];
            model.bbsName = [forumList[i] objectForKey:@"bbsname"];
            model.bbstype = [forumList[i] objectForKey:@"bbstype"];
            model.bbsimgurl = [forumList[i] objectForKey:@"imgurl"];
            model.lastreplydate = [forumList[i] objectForKey:@"lastreplydate"];
            model.postusername = [forumList[i] objectForKey:@"postusername"];
            model.replycounts = [forumList[i] objectForKey:@"replycounts"];
            model.title = [forumList[i] objectForKey:@"title"];
            model.topicid = [forumList[i] objectForKey:@"topicid"];
            [tempAsy addObject:model];
        }
        if(!forumArray){
            NSLog(@"123");
            forumArray = [[NSMutableArray alloc]init];//如果没有就初始化一个。
        }else{
            NSLog(@"456");
            [forumArray removeAllObjects];//如果有就移除掉里面的子元素.
        }
        forumArray = tempAsy;
        [_forumTableView reloadData];//得到数据之后。刷新tableview
        [_forumTableView headerEndRefreshing];
        pageCount = 2;//下拉一次之后pageCount = 2;
    } fail:^{
        NSLog(@"下拉失败。");
    }];
}
#pragma mark ---上拉事件------
-(void)getNextPage:(int)page{
    if(pageCount >1){
        if(forumArray){
            NSString *url = [NSString stringWithFormat:@"http://app.api.autohome.com.cn/autov3.2//club/jinghuahome-a2-pm1-v3.2.0-p%d-s20.html",pageCount];
            [AFNetworkTool JSONDataWithUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] success:^(id json) {
                NSDictionary *dic = (NSDictionary *)json;
                NSDictionary *result = [dic objectForKey:@"result"];
                NSArray *forumList = [result objectForKey:@"list"];
                NSLog(@"forumlist %ld",forumList.count);
                for (int i = 0; i<forumList.count; i++) {
                    ForumModel *model = [[ForumModel alloc]init];
                    model.bbsId = [forumList[i] objectForKey:@"bbsid"];
                    model.bbsName = [forumList[i] objectForKey:@"bbsname"];
                    model.bbstype = [forumList[i] objectForKey:@"bbstype"];
                    model.bbsimgurl = [forumList[i] objectForKey:@"imgurl"];
                    model.lastreplydate = [forumList[i] objectForKey:@"lastreplydate"];
                    model.postusername = [forumList[i] objectForKey:@"postusername"];
                    model.replycounts = [forumList[i] objectForKey:@"replycounts"];
                    model.title = [forumList[i] objectForKey:@"title"];
                    model.topicid = [forumList[i] objectForKey:@"topicid"];
                    [forumArray addObject:model];
                }
                NSLog(@"上拉");
                [_forumTableView reloadData];//得到数据之后。刷新tableview
                [_forumTableView footerEndRefreshing];
                pageCount++;
            } fail:^{
                NSLog(@"上拉失败");
            }];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return forumArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    
    ForumModel *model = forumArray[indexPath.row];
//    cell.textLabel.text = model.bbsName;
//    //图片
    NSLog(@"%@",model.bbsimgurl);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 80)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.bbsimgurl]] placeholderImage:[UIImage imageNamed:@"selected_no"]];
    [cell.contentView addSubview:imageView];
//
//    //title
    CGFloat height = [self heightForString:model.title fontSize:16 andWidth:width-120];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(116, 8, width-120, height)];
    titleLabel.text = model.title;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:titleLabel];
//
//    //post name
    UILabel *postnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(116, 70, 100, 25)];
    postnameLabel.text = model.postusername;
    postnameLabel.font = [UIFont systemFontOfSize:14];
    postnameLabel.textColor = UIColorFromRGB(0x555555);
    [cell.contentView addSubview:postnameLabel];
    
//    //replay
    UILabel *replayLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-100, 50, 90, 25)];
    replayLabel.text = [NSString stringWithFormat:@"%@回",model.replycounts];
    NSLog(@"%@",model.replycounts);
    replayLabel.textAlignment = NSTextAlignmentRight;
    replayLabel.font = [UIFont systemFontOfSize:14];
    replayLabel.textColor = UIColorFromRGB(0x555555);
    [cell.contentView addSubview:replayLabel];
//
//    //bbsname
    UILabel *bbsnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width-150, 70, 140, 25)];
    bbsnameLabel.text = model.bbsName;
    bbsnameLabel.textAlignment = NSTextAlignmentRight;
    bbsnameLabel.font = [UIFont systemFontOfSize:14];
    bbsnameLabel.textColor = UIColorFromRGB(0x555555);
    [cell.contentView addSubview:bbsnameLabel];

    return cell;
}
#pragma mark didSelected
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumModel *model = forumArray[indexPath.row];
    ForumWebView *FVC = [[ForumWebView alloc]init];
    FVC.detailUrl = [[NSString stringWithFormat:@"http://club.autohome.com.cn/bbs/mobile-c-%@-%@-%d.html?v=3.1&pageSize=20&clientType=IOS&openlink=0&gprs=0",model.bbsId,model.topicid,1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:FVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 计算文本高度
-(CGFloat)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

@end
