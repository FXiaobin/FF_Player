//
//  ViewController.m
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/4.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "ViewController.h"
#import "SingleViewController.h"
#import "AllSwitchViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property  (nonatomic,strong) UITableView *tableView;



@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"视频播放器全屏切换";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *titls = @[@"播放器视图旋转,其他不旋转",@"播放器视图和其他视图全部旋转(需要APPDelegate属性支持)"];
    cell.textLabel.text = titls[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SingleViewController *vc = [[SingleViewController alloc] init];
        //[self.navigationController presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        AllSwitchViewController *vc = [[AllSwitchViewController alloc] init];
        //[self.navigationController presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
