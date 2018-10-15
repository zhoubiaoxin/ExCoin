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
@property(nonatomic,strong)NSArray * dataArr;
@property(nonatomic,assign)BOOL hasPaixu;
@end

@implementation MarketListViewController1

-(void)viewWillAppear:(BOOL)animated{
    [self createData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 71 -44-49);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#151935"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createData) name:@"refresh" object:nil];
    [self createData];
}
-(void)createData{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"paixu"];
    NSString * str1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"paixustate"];
    NSString * str2 = @"";
    if (str.length !=0&&str1.length !=0) {
        if ([str1 isEqualToString:@"up"]) {
            self.hasPaixu = YES;
        }else{
            self.hasPaixu = NO;
        }
        str2 = [NSString stringWithFormat:@" ORDER BY %@ DESC",str];
    }else{
        self.hasPaixu = YES;
        str2 = @" ORDER BY allstr DESC";
    }
    NSString * str3 = @"WHERE store = '1'";
    NSString * str4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"sousu"];
    NSString * str5 = @"";
    if (str4.length !=0){
        str5 = [NSString stringWithFormat:@" AND tickername like '%@%@'",[str4 uppercaseString],@"%"];
    }
    
    NSArray * arr = [MarketModel objectsWhere:[NSString stringWithFormat:@"%@%@%@",str3,str5,str2] arguments:nil];
    _dataArr = arr;
    if(arr.count>0){
        [self.tableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketModel * model;
    if (self.hasPaixu) {
        model = _dataArr[indexPath.row];
    }else{
        model = _dataArr[_dataArr.count-1- indexPath.row];
    }
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
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (indexPath.row%2 ==0) {
        cell.backgroundColor = [UIColor colorWithHex:@"#151935"];
    }else{
        cell.backgroundColor = [UIColor colorWithHex:@"#1b1e3d"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.storeBtn.tag = 100+indexPath.row;
    [cell.storeBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)storeBtnClick:(UIButton*)btn{
    MarketModel * model;
    if (self.hasPaixu) {
        model = _dataArr[btn.tag-100];
    }else{
        model = _dataArr[_dataArr.count-1- btn.tag+100];
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ([model.store isEqualToString:@"0"]) {
        param[@"store"] = @"1";
    }else{
        param[@"store"] = @"0";
    }
    [MarketModel updateObjectsSet:param Where:[NSString stringWithFormat:@"WHERE tickername = '%@'",model.tickername] arguments:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [self createData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketModel * model;
    if (self.hasPaixu) {
        model = _dataArr[indexPath.row];
    }else{
        model = _dataArr[_dataArr.count-1- indexPath.row];
    }
    NSDictionary *dataDic = [NSDictionary dictionaryWithObject:model.tickername forKey:@"info"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"marketDetail" object:dataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
