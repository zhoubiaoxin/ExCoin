//
//  MarketListViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/18.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketListViewController1.h"
#import "MarketCell.h"
#import "MarketDetailViewController.h"

@interface MarketListViewController1 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation MarketListViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 71 -44-49);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#1b1e3d"];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    [self createData];
}
-(void)createData{

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MarketModel * model = [[MarketModel alloc] init];
    
    
    MarketCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //解决xib复用数据混乱问题
    if (nil == cell) {
        cell= (MarketCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"MarketCell" owner:self options:nil]  lastObject];
    }else{
        //删除cell的所有子视图
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    [cell setCellModel:model];
    if (indexPath.row%2 ==0) {
        cell.backgroundColor = [UIColor colorWithHex:@"#1b1e3d"];
    }else{
        cell.backgroundColor = RGB(21, 25, 53);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MarketModel * market = [[MarketModel alloc] init];
//    NSDictionary * dic = [NSDictionary dictionaryWithObject:market.name forKey:@"marketName"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"marketDetail" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"marketDetail" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
