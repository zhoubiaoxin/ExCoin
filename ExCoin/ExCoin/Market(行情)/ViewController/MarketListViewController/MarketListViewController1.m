//
//  MarketListViewController.m
//  ExCoin
//
//  Created by 周飙 on 2018/9/18.
//  Copyright © 2018年 周飙. All rights reserved.
//

#import "MarketListViewController1.h"
#import "MarketCell.h"

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
//    [self.tableView registerNib:[UINib nibWithNibName:@"MarketCell" bundle:nil] forCellReuseIdentifier:@"JHCELL"];

//    [_tableView registerClass:[MarketCell class] forCellReuseIdentifier:@"MarketCell"];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MarketCell" owner:self options:nil] firstObject];
    MarketModel * model = [[MarketModel alloc] init];
    [cell setCellModel:model];
    if (indexPath.row%2 ==0) {
        cell.backgroundColor = [UIColor colorWithHex:@"#1b1e3d"];
    }else{
        cell.backgroundColor = RGB(21, 25, 53);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
