//
//  BasketViewController.m
//  雄辉汽车
//
//  Created by ianc-ios on 15/11/16.
//  Copyright (c) 2015年 彭雄辉10/9. All rights reserved.
//

#import "BasketViewController.h"
#import "basketModel.h"
#import "Macro.h"
#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"

@interface BasketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tempAsy;
}
@end

@implementation BasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    self.tableView.tableHeaderView = view;
    tempAsy = [[NSMutableArray alloc]init];

}
-(void)viewWillAppear:(BOOL)animated{
    
    if(self.basketAsy.count == 0){
        NSLog(@"123");
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        view.tag = 99;
        view.backgroundColor = [UIColor yellowColor];
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2,(SCREEN_HEIGHT-128)/2, 200, 20)];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = @"空的~";
        [view addSubview:textField];
        [self.view addSubview:view];
    }
}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.basketAsy.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    basketModel *model = self.basketAsy[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"数量%ld",model.count];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.carModel.specpicString]] placeholderImage:[UIImage imageNamed:@"selected_yes.png"]];
    
    {//图片
        UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 70)];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.carModel.specpicString]] placeholderImage:[UIImage imageNamed:@"selected_yes.png"]];
        [cell.contentView addSubview:headImageView];
    }
    {//名字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, SCREEN_WIDTH-95, 20)];
        titleLabel.text = [NSString stringWithFormat:@"%@",model.carModel.specnameString];
        [cell.contentView addSubview:titleLabel];
    }
    
    {//数量 -
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
        btn.frame =CGRectMake(100, 40, 25, 25);
        btn.backgroundColor = [UIColor grayColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:25];
        btn.tag = indexPath.row+1000;
        [btn setTitle:@"-" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(minusCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    {//数量
        UITextField *countField = [[UITextField alloc]initWithFrame:CGRectMake(127, 40, 25, 25)];
        countField.text = [NSString stringWithFormat:@"%ld",model.count];
        countField.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:countField];
    }
    {//数量 +
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        btn.frame =CGRectMake(154, 40, 25, 25);
        btn.backgroundColor = [UIColor grayColor];
        btn.tag = indexPath.row+500;
        btn.titleLabel.font = [UIFont systemFontOfSize:25];
        [btn setTitle:@"+" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addCount:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    
    return cell;
}

-(void)minusCount:(id)sender{
    NSLog(@"---12");
    UIButton *btn = (UIButton *)sender;
    tempAsy = (NSMutableArray *)[NSArray arrayWithArray:self.basketAsy];
    basketModel *model = self.basketAsy[btn.tag-1000];
    if (model.count<2) {
        [self.view makeToast:@"数量不能小于1" duration:1 position:@"center"];
        return;
    }
    model.count = model.count -1;
    [self.tableView reloadData];
}
-(void)addCount:(id)sender{
    NSLog(@"---12");
    
    UIButton *btn = (UIButton *)sender;
    tempAsy = (NSMutableArray *)[NSArray arrayWithArray:self.basketAsy];
    basketModel *model = self.basketAsy[btn.tag-500];
    if(model.count > 99){
        return;
    }
    model.count = model.count + 1;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)vcBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
