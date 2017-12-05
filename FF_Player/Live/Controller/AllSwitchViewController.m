//
//  AllSwitchViewController.m
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/4.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "AllSwitchViewController.h"
#import "AppDelegate.h"
#import "PlayerView.h"
#import <Masonry.h>

@interface AllSwitchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property  (nonatomic,strong) UITableView *tableView;

@property  (nonatomic,assign) BOOL isFull;

@property  (nonatomic,strong) PlayerView *playerView;

@end

@implementation AllSwitchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个视频",(long)indexPath.row];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height - 300)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300) urlSring:@""];
    
    __weak typeof(self) weakSelf = self;
    self.playerView.playerBtnActionBlock = ^(PlayerView *aPlayerView, NSInteger index) {
        if (index == 0) {
            
        }else if (index == 1){
            [weakSelf swithchScreen];
            
        }else if (index == 2){
            if (weakSelf.isFull) {
                weakSelf.isFull = YES;
                [weakSelf swithchScreen];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    };
    [self.view addSubview:self.playerView];
    
    
    
}

- (void)swithchScreen{
    _isFull = !_isFull;
    
    if (_isFull) {
        
        //设置屏幕的转向为竖屏
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = YES;
        
        [self orientationToPortrait:UIInterfaceOrientationLandscapeRight];
        self.playerView.frame = self.view.bounds;
        
        //        //旋转前
        //        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2 * 2);
        //        CGFloat scale = 2.0;
        //        transform = CGAffineTransformScale(transform, scale, scale);
        //        self.self.playerView.transform = transform;
        //
        //        //旋转动画
        //        [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        //            self.self.playerView.transform = CGAffineTransformIdentity;
        //            self.self.playerView.frame = self.view.bounds;
        //        }completion:^(BOOL finished) {
        //
        //        }];
        
    }else{
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.allowRotation = NO;
        
        [self orientationToPortrait:UIInterfaceOrientationPortrait];
        self.self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
        
        //        //缩放动画
        //        CGFloat scale = 2.0;
        //        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        //        self.self.playerView.transform = transform;
        //        self.self.playerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.self.playerView.frame), CGRectGetHeight(self.self.playerView.frame));
        //        self.self.playerView.transform = CGAffineTransformRotate(transform, M_PI_2);
        //
        //        [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
        //             self.self.playerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        //
        //             self.self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
        //
        //         } completion:^(BOOL finished) {
        //
        //         }];
    }
    
}

//强制旋转屏幕
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
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

@end
