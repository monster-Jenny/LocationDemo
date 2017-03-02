//
//  RootViewController.m
//  LocationDemo
//
//  Created by Monster on 2017/3/1.
//  Copyright © 2017年 Monster. All rights reserved.
//

#import "RootViewController.h"
#import "NativeLocationViewCtl.h"
#import "BaiDuLocationViewCtl.h"
#import "GaoDeLocationViewCtl.h"
#import "CompareViewCtl.h"
#import <Masonry.h>

NSString * const cellIdentify = @"cellIdentify";

@interface RootViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView * tableView;

@property (strong, nonatomic) NSArray * dataSource;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutUI];
}

#pragma mark - UI

- (void)layoutUI
{
    self.dataSource = @[@"百度地图定位+地图",@"高德地图定位+地图",@"iOS原生定位+地图",@"三种定位坐标同时显示",@"同一地点多次定位"];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            BaiDuLocationViewCtl * viewCtl = [[BaiDuLocationViewCtl alloc] init];
            viewCtl.title = self.dataSource[indexPath.row];
            [self.navigationController pushViewController:viewCtl animated:YES];
        }
            break;
        case 1:
        {
            GaoDeLocationViewCtl * viewCtl = [[GaoDeLocationViewCtl alloc] init];
            viewCtl.title = self.dataSource[indexPath.row];
            [self.navigationController pushViewController:viewCtl animated:YES];
        }
            break;
        case 2:
        {
            NativeLocationViewCtl * viewCtl = [[NativeLocationViewCtl alloc] init];
            viewCtl.title = self.dataSource[indexPath.row];
            [self.navigationController pushViewController:viewCtl animated:YES];
        }
            break;
        case 3:
        {
            CompareViewCtl * viewCtl = [[CompareViewCtl alloc] init];
            viewCtl.title = self.dataSource[indexPath.row];
            [self.navigationController pushViewController:viewCtl animated:YES];
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
