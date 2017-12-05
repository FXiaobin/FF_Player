//
//  SingleViewController.m
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/4.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "SingleViewController.h"

#import "PlayerView.h"
#import <PLPlayerKit.h>
#import <UIImageView+WebCache.h>
#import "LessonModel.h"
#import <AFNetworking.h>
#import "LessonCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//直播列表接口
#define WYLIVELISTINTERFACE @"http://www.guxuantang.com/app/lesson/live"

@interface SingleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) BOOL isFull;

@property  (nonatomic,strong) PlayerView *playerView;

@property  (nonatomic,strong) UITableView *tableView;

@property  (nonatomic,strong) NSMutableArray *dataArr;

///直播地址
@property  (nonatomic,strong) NSString *rtmp_url;

@end

@implementation SingleViewController

-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)queryData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.0;

    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain", nil]];
    
    [manager GET:WYLIVELISTINTERFACE parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSArray *data = responseObject[@"data"];
        [self.dataArr removeAllObjects];
        for (NSDictionary *dic in data) {
            LessonModel *model = [LessonModel makeModelWithDic:dic];
            [self.dataArr addObject:model];
        }
        
        [self.tableView reloadData];
        
        NSArray *live_url = responseObject[@"live_url"];
        self.rtmp_url = live_url.firstObject[@"value"];
        ///是否有直播没有根据时间来判断 这里是不合理的直播判断 示例而已
        if (self.rtmp_url.length) {
            self.playerView.urlStr = self.rtmp_url;
             [self.playerView.player play];
            self.playerView.playBtn.selected = YES;
        }
     
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView.player stop];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LessonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LessonCell" forIndexPath:indexPath];
    LessonModel *model = self.dataArr[indexPath.row];
    cell.startTimeLabel.text = model.start_time;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.lesson_name,model.profile];
    cell.teacherLabel.text = [NSString stringWithFormat:@"主讲人:%@",model.username];
    if (indexPath.row == 0) {
        NSString *pic = [model.lesson_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.playerView.player.launchView sd_setImageWithURL:[NSURL URLWithString:pic]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.playerView.player stop];
    LessonModel *model = self.dataArr[indexPath.row];
    NSString *videoUrl = model.video_url.length ? model.video_url : self.rtmp_url;
    if (videoUrl.length <= 0) {
        videoUrl = @"http://gxtvod.58hengku.com/gxt/record/2017-12-04/gxt/beiyong2/2017-12-04-14:16:02_2017-12-04-15:05:04.m3u8";
    }
    [self.playerView setUrlStr:videoUrl];
    [self.playerView.player play];
    self.playerView.playBtn.selected = YES;
    
    ///这个要放到后面 因为在设置url的时候 播放器是重新创建的
    //NSString *pic = [model.lesson_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[self.playerView.player.launchView sd_setImageWithURL:[NSURL URLWithString:pic]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height - 300)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 86;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LessonCell" bundle:nil] forCellReuseIdentifier:@"LessonCell"];
    [self.view addSubview:self.tableView];
    
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300) urlSring:@"rtmp://gxtplay.58hengku.com/gxt/beiyong1"];
   
    __weak typeof(self) weakSelf = self;
    self.playerView.playerBtnActionBlock = ^(PlayerView *aPlayerView, NSInteger index) {
        if (index == 0) {
            NSLog(@"---- 播放 ----");
            aPlayerView.playBtn.selected = !aPlayerView.playBtn.selected;
            
            if (aPlayerView.playBtn.selected) {
                [aPlayerView.player resume];
                
            }else{
                [aPlayerView.player pause];
                
            }
          
        }else if (index == 1){
            [weakSelf swithchScreen];
            
        }else if (index == 2){
            NSLog(@"---- 返回 ----");
            if (weakSelf.isFull) {
                weakSelf.isFull = YES;
                [weakSelf swithchScreen];
            }else{
                [aPlayerView.player stop];
                [weakSelf.navigationController popViewControllerAnimated:YES];
               // [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }
    };
    [self.view addSubview:self.playerView];
    
    [self queryData];
}

- (void)swithchScreen{
    _isFull = !_isFull;
    if (_isFull) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return _isFull ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)deviceOrientationDidChange{
    NSLog(@"deviceOrientationDidChange:%ld",(long)[UIDevice currentDevice].orientation);
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        [self orientationChange:NO];
        //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
    } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        [self orientationChange:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)orientationChange:(BOOL)landscapeRight{
    if (landscapeRight) {
        [UIView animateWithDuration:0.2f animations:^{
            self.playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            self.playerView.transform = CGAffineTransformMakeRotation(0);
            self.playerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
        }];
    }
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
