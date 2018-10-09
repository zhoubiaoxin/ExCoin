//
//  MarketListViewController5.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/18.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketListViewController5.h"
#import "MarketCell.h"
#import "MarketDetailViewController.h"

@interface MarketListViewController5 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArr;

@end

@implementation MarketListViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 71 -44-49);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#1b1e3d"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    [self createData];
}
-(void)createData{
    _dataArr = [MarketModel objectsWhere:@"WHERE tickername like '%CTE'" arguments:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MarketModel * model = _dataArr[indexPath.row];
    
    
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
        cell.backgroundColor = [UIColor colorWithHex:@"#151935"];
    }else{
        cell.backgroundColor = [UIColor colorWithHex:@"#1b1f3d"];
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
