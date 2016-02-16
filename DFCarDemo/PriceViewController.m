//
//  PriceViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/10/15.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "PriceViewController.h"
#import "AFNetworkTool.h"
#import "CarListModel.h"
#import "DealerModel.h"
#import "MJRefresh.h"
#import "Macro.h"
#import "UIImageView+WebCache.h"
#import "UILabelCenterLine.h"
//#import "AttributedLabel.h"
#import "DFAttributedLabel.h"
#import "DFCoreAnimation.h"
#import "BasketViewController.h"
#import "basketModel.h"

#define titleWidth SCREEN_WIDTH-115
#define rightMargin SCREEN_WIDTH-100

@interface PriceViewController()<UITableViewDataSource,UITableViewDelegate,ThrowLineToolDelegate>

@end

@implementation PriceViewController
{
    NSMutableArray *priceAsy;
    NSMutableArray *tempAsy;
    NSInteger page;
    
    CGFloat beginY;
    UIImageView *basketImageView;
    
    NSMutableArray *basketAsy;
}

@synthesize tableView = _tableView;
@synthesize urlString = _urlString;


-(void)viewDidLoad{
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self createUI];
}

-(void)createUI{
    self.navigationItem.title = @"降价";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    priceAsy = [[NSMutableArray alloc]init];
    tempAsy = [[NSMutableArray alloc]init];
    basketAsy = [[NSMutableArray alloc]init];
    NSLog(@"user default basketAsy %ld",basketAsy.count);
    
    [_tableView addHeaderWithTarget:self action:@selector(getNewData)];
    [_tableView addFooterWithTarget:self action:@selector(getMoreData)];
    [_tableView headerBeginRefreshing];
    
    
    //购物车
    
    basketImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-180, 60, 60)];
    basketImageView.image = [UIImage imageNamed:@"shopbasket.png"];
    
    basketImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBasket:)];
    [basketImageView addGestureRecognizer:tap];
    
    [self.view addSubview:basketImageView];
    
}



#pragma mark getData
-(void)getMoreData{
    page++;
    [self getData];
}
-(void)getNewData{
    page = 1;
    [tempAsy removeAllObjects];
    [self getData];
}
-(void)getData{
    _urlString = [NSString stringWithFormat:@"http://app.api.autohome.com.cn/autov3.2/dealer/pdspecs-a2-pm1-v3.2.0-pi440000-c440300-o0-b0-ss0-sp0-p%ld-s20.html",page];
    NSString *url = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSDictionary *result = [dic objectForKey:@"result"];
        NSArray *carlist = [result objectForKey:@"carlist"];
        for(int i = 0;i<carlist.count;i++){
            NSDictionary *dic = [carlist[i] objectForKey:@"dealer"];
            DealerModel *dealermodel = [[DealerModel alloc]init];
            dealermodel.idString = [dic objectForKey:@"id"];
            dealermodel.nameString = [dic objectForKey:@"name"];
            dealermodel.shortnameString = [dic objectForKey:@"shortname"];
            dealermodel.cityString = [dic objectForKey:@"city"];
            dealermodel.addressString = [dic objectForKey:@"address"];
            dealermodel.phoneString = [dic objectForKey:@"phone"];
            dealermodel.phonestyledString = [dic objectForKey:@"phonestyled"];
            dealermodel.is400String = [dic objectForKey:@"is400"];
            dealermodel.is24hourString = [dic objectForKey:@"is24hour"];
            dealermodel.latString = [dic objectForKey:@"lat"];
            dealermodel.lonString = [dic objectForKey:@"lon"];
            dealermodel.majorString = [dic objectForKey:@"major"];
            dealermodel.isauthString = [dic objectForKey:@"isauth"];
            dealermodel.ispromotionString = [dic objectForKey:@"ispromotion"];
            dealermodel.specpriceString = [dic objectForKey:@"specprice"];
            dealermodel.seriespriceString = [dic objectForKey:@"seriesprice"];
            dealermodel.scopestatusString = [dic objectForKey:@"scopestatus"];
            dealermodel.scopenameString = [dic objectForKey:@"scopename"];
            dealermodel.loworminpriceString = [dic objectForKey:@"loworminprice"];
            dealermodel.ishavelowpriceString = [dic objectForKey:@"ishavelowprice"];
            
            CarListModel *model = [[CarListModel alloc]init];
            model.dealerModel = dealermodel;
            model.specidString = [carlist[i] objectForKey:@"specid"];
            model.specnameString = [carlist[i] objectForKey:@"specname"];
            model.specpicString = [carlist[i] objectForKey:@"specpic"];
            model.seriesidString = [carlist[i] objectForKey:@"seriesid"];
            model.seriesnameString = [carlist[i] objectForKey:@"seriesname"];
            model.inventorystateString = [carlist[i] objectForKey:@"inventorystate"];
            model.styledinventorystateString = [carlist[i] objectForKey:@"styledinventorystate"];
            model.dealerpriceString =[carlist[i] objectForKey:@"dealerprice"];
            model.fctpriceString = [carlist[i] objectForKey:@"fctprice"];
            model.specstatusString = [carlist[i] objectForKey:@"specstatus"];
            model.articletypetring = [carlist[i] objectForKey:@"articletype"];
            model.articleidString = [carlist[i] objectForKey:@"articleid"];
            model.ordercountString = [carlist[i] objectForKey:@"ordercount"];
            model.enddateString = [carlist[i] objectForKey:@"enddate"];
            model.assellphoneString = [carlist[i] objectForKey:@"assellphone"];
            model.orderrangetitleString = [carlist[i] objectForKey:@"orderrangetitle"];
            model.orderrangeString = [carlist[i] objectForKey:@"orderrange"];
            
            [tempAsy addObject:model];
        }
        priceAsy = [NSMutableArray arrayWithArray:tempAsy];
        NSLog(@"条数   %ld",priceAsy.count);
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } fail:^{
        NSLog(@"网络异常");
    }];
    
    
}

#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return priceAsy.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"pricecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//无点击响应
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    CarListModel *model = priceAsy[indexPath.row];
    DealerModel *dealerModel = model.dealerModel;
    {//图片
        UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 100,75)];
        [headerImage sd_setImageWithURL:[NSURL URLWithString:model.specpicString ] placeholderImage:[UIImage imageNamed:@"selected_yes"]];
        [cell.contentView addSubview:headerImage];
    }
    {//立即拨打电话
        UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 85, 100,30)];
        telLabel.backgroundColor = UIColorFromRGB(0x008b45);
        telLabel.textAlignment = NSTextAlignmentCenter;
        telLabel.font = [UIFont systemFontOfSize:13];
        telLabel.textColor = [UIColor whiteColor];
        telLabel.text = @"立即拨打电话";
        [cell.contentView addSubview:telLabel];
    }
    {//标题
        NSString *titleString = [NSString stringWithFormat:@"%@,%@",model.seriesnameString,model.specnameString];
        CGFloat height = [self heightForString:titleString fontSize:16 andWidth:titleWidth];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, titleWidth, height)];
        titleLabel.numberOfLines = 0;
        titleLabel.text = titleString;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:titleLabel];
    }
    {//现价
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 43, 60, 20)];
        label.text = model.dealerpriceString;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = UIColorFromRGB(0xffb90f);
        [cell.contentView addSubview:label];
    }
    {//原价
        CGSize Labelwidth = [self ReturnWidth:16 string:model.fctpriceString];
        UILabelCenterLine *label = [[UILabelCenterLine alloc]initWithFrame:CGRectMake(170, 43, Labelwidth.width, 20)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = model.fctpriceString;
        label.textColor = UIColorFromRGB(0x000000);
        [cell.contentView addSubview:label];
        
    }
    {//降价
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(rightMargin, 23, 100, 20)];
        label.text = [NSString stringWithFormat:@"降%0.2f",[model.fctpriceString floatValue] - [model.dealerpriceString floatValue]];
        label.textColor = UIColorFromRGB(0xff2222);
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
    }
    {//地址
        NSString *address = [NSString stringWithFormat:@"%@ | %@",dealerModel.cityString,dealerModel.shortnameString];
        CGSize labelWidth = [self ReturnWidth:14 string:address];
        DFAttributedLabel *label = [[DFAttributedLabel alloc]initWithFrame:CGRectMake(110, 65, labelWidth.width, 20)];
        label.text = address;
        //        [label setFont:[UIFont fontWithName:@"Zapfino" size:12] range:NSMakeRange(0, 3)];
        [label setTextColor:[UIColor redColor] range:NSMakeRange(0, 3)];//这里第三个是空格
        [cell.contentView addSubview:label];
    }
    {//车辆充足
        
    }
    {//寻问最低价
        
    }
    {//售本省
        
    }
    {//24H
        
    }
    {//
        
    }
    
    {//加入购物车
        UIButton *buyButton = [[UIButton alloc]initWithFrame:CGRectMake(rightMargin, 60, 70, 30)];
        [buyButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        buyButton.backgroundColor = [UIColor redColor];
        buyButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        buyButton.tag = 1000+indexPath.row;
        
        buyButton.layer.cornerRadius = 5;
        buyButton.layer.masksToBounds = YES;
        
        [buyButton addTarget:self action:@selector(addBuyBasket:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:buyButton];
        
    }
    
    return cell;
}

#pragma mark 加入购物车按钮点击事件
-(void)addBuyBasket:(id)sender{
    UIButton *buyBtn = (UIButton *)sender;
    NSInteger indexRow = buyBtn.tag - 1000;
    
    //new indexpath。与所点击按钮处于同一位置
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexRow inSection:0];
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexpath];
    CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    CGFloat beginY = rectInSuperview.origin.y+5;//计算图片y值
    
    //new一个执行动画的view
    CarListModel *modelThere = priceAsy[indexRow];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,beginY, 100, 75)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:modelThere.specpicString] placeholderImage:[UIImage imageNamed:@"shopbasket.png"]];
    imageView.tag = 999;
    [self.view addSubview:imageView];
    
    //加入到购物车。
    NSInteger flag = 0;
    NSArray *asy = [NSArray arrayWithArray:basketAsy];
    for (int i = 0;i<asy.count ;i++) {//先遍历一下购物车数组。如果里面有
        basketModel *model = asy[i];
        
        NSLog(@"what is %@ & %@",model.carModel.specidString,modelThere.specidString);
        if(model.carModel.specidString == modelThere.specidString){//意思就是说。这个物品、已经加入过一次了。
            //                model.count++;
            basketModel *modell = basketAsy[i];
            modell.count = modell.count+1;
            flag = 10;
        }
    }
    if(flag == 0){
        basketModel *model = [[basketModel alloc]init];
        model.carModel = modelThere;
        model.count = 1;
        [basketAsy addObject:model];
    }
    
    [self showAnimation:imageView];//执行动画
}
-(void)showAnimation:(UIImageView *)imageView{
    DFCoreAnimation *throwLineTool = [DFCoreAnimation sharedTool];
    throwLineTool.delegate = self;
    
    CGFloat startX = CGRectGetMidX(imageView.frame);
    CGFloat startY = CGRectGetMidY(imageView.frame);
    
    CGFloat endX = SCREEN_WIDTH-50;
    CGFloat endY = SCREEN_HEIGHT-180;
    
    CGFloat height = 50+arc4random()%40;
    [throwLineTool throwObject:imageView from:CGPointMake(startX, startY) to:CGPointMake(endX, endY) height:height duration:1];
}
-(void)animationDidFinish{//动画结束完。购物车弹动
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:999];
    [imageView removeFromSuperview];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fillMode = kCAFillModeBackwards;
    scaleAnimation.repeatCount = 3;
    scaleAnimation.duration = 0.1;
    
    [basketImageView.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
}

//点击购物车
-(void)addBasket:(id)sender{
    BasketViewController *basketVC = [[BasketViewController alloc]init];
    basketVC.basketAsy = basketAsy;
    [self.navigationController presentViewController:basketVC animated:YES completion:nil];
}

#pragma mark 计算高度和宽度
- (CGFloat) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}
-(CGSize)ReturnWidth:(float)fontSize string:(NSString *)str{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    CGSize Mysize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return Mysize;
}

@end
