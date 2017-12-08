//
//  PlayerView.m
//  FF_ScrennSwitch
//
//  Created by fanxiaobin on 2017/12/4.
//  Copyright © 2017年 fanxiaobin. All rights reserved.
//

#import "PlayerView.h"
#import <Masonry.h>

@implementation PlayerView

-(UIView *)bottomMaskView{
    if (_bottomMaskView == nil) {
        _bottomMaskView = [UIView new];
    }
    return _bottomMaskView;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
    }
    return _bgView;
}

-(UIButton *)playBtn{
    if (_playBtn == nil) {
        _playBtn = [[UIButton alloc] init];
        //_playBtn.backgroundColor = [UIColor cyanColor];
        [_playBtn setImage:[UIImage imageNamed:@"bf"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.tag = 10000;
    }
    return _playBtn;
}

-(UIButton *)fullBtn{
    if (_fullBtn == nil) {
        _fullBtn = [[UIButton alloc] init];
        [_fullBtn setImage:[UIImage imageNamed:@"fasx"] forState:UIControlStateNormal];
        [_fullBtn addTarget:self action:@selector(playerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _fullBtn.tag = 10001;
    }
    return _fullBtn;
}

-(UIButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        //_backBtn.backgroundColor = [UIColor cyanColor];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(playerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = 10002;
    }
    return _backBtn;
}

-(UISlider *)progressSlider{
    if (_progressSlider == nil) {
        _progressSlider = [UISlider new];
        _progressSlider.minimumValue = 0.0;
        _progressSlider.maximumValue = 1.0;
        _progressSlider.value = 0.0;
        [_progressSlider setThumbImage:[UIImage imageNamed:@"my_icon01"] forState:UIControlStateNormal];
        [_progressSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}

-(UILabel *)startTimeLabel{
    if (_startTimeLabel == nil) {
        _startTimeLabel = [UILabel new];
        _startTimeLabel.text = @"00:00:00";
        _startTimeLabel.font = [UIFont systemFontOfSize:10];
        _startTimeLabel.textColor = [UIColor whiteColor];
        
    }
    return _startTimeLabel;
}

-(UILabel *)endTimeLabel{
    if (_endTimeLabel == nil) {
        _endTimeLabel = [UILabel new];
        _endTimeLabel.text = @"00:00:00";
        _endTimeLabel.font = [UIFont systemFontOfSize:10];
        _endTimeLabel.textColor = [UIColor whiteColor];
        
    }
    return _endTimeLabel;
}

- (void)playerBtnAction:(UIButton *)sender{
    if (self.playerBtnActionBlock) {
        self.playerBtnActionBlock(self, sender.tag - 10000);
    }
}

-(PLPlayer *)player{
    if (_player == nil) {
        _player = [[PLPlayer alloc] initWithURL:[NSURL URLWithString:_urlStr] option:nil];
        _player.delegate = self;
    }
    return _player;
}

-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [_player.playerView removeFromSuperview];
    _player = nil;
    [self addSubview:self.player.playerView];
    [self insertSubview:self.player.playerView atIndex:0];
    
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.player.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.player.playerView);
    }];
    
}

-(instancetype)initWithFrame:(CGRect)frame urlSring:(NSString *)urlString{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
        _urlStr = urlString;
        
        [self addSubview:self.player.playerView];
        
        [self addSubview:self.bottomMaskView];
        [self.bottomMaskView addSubview:self.bgView];
        [self addSubview:self.backBtn];
        [self.bottomMaskView addSubview:self.playBtn];
        [self.bottomMaskView addSubview:self.progressSlider];
        [self.bottomMaskView addSubview:self.startTimeLabel];
        [self.bottomMaskView addSubview:self.endTimeLabel];
        [self.bottomMaskView addSubview:self.fullBtn];
        
        [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.player.launchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.player.playerView);
        }];
        
        [self.bottomMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(46.0);
        }];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomMaskView);
        }];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(30);
            make.width.and.height.mas_equalTo(30.0);
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomMaskView).offset(10);
            make.centerY.equalTo(self.bottomMaskView);
            make.width.and.height.mas_equalTo(30.0);
        }];
        
        [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomMaskView.mas_right).offset(-10);
            make.centerY.equalTo(self.bottomMaskView);
            make.width.and.height.mas_equalTo(30.0);
        }];
        
        [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playBtn.mas_right).offset(10);
            make.centerY.equalTo(self.bottomMaskView).offset(-5);
            make.right.equalTo(self.fullBtn.mas_left).offset(-10);
        }];
        
        [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.progressSlider);
            make.top.equalTo(self.progressSlider.mas_bottom).offset(5);
        }];
        
        [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.progressSlider.mas_right);
            make.centerY.equalTo(self.startTimeLabel);
        }];
        
    }
    return self;
}

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state{
    if  (state == PLPlayerStatusPlaying) {
        [self updateUIWithPlayer:player];
    }
    
    
    
}

- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData{
    //NSLog(@"-------- +hahha --------");
}

- (nonnull AudioBufferList *)player:(nonnull PLPlayer *)player willAudioRenderBuffer:(nonnull AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
    
    //NSLog(@"-------- -hahha --------");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIWithPlayer:player];
    });
    
    
    return nil;
}

- (void)updateUIWithPlayer:(PLPlayer *)player{
    
    //double total = player.totalDuration.value / player.totalDuration.timescale;
    double total = CMTimeGetSeconds(player.totalDuration);
    // 相当于 duration.value / duration.timeScale
    double current = CMTimeGetSeconds(player.currentTime);
    self.progressSlider.value = current / total;
    
    self.startTimeLabel.text = [self timeFromSeconds:current];
    self.endTimeLabel.text = [self timeFromSeconds:total];
}

-(NSString *)timeFromSeconds:(int)seconds
{
    int m = seconds / 60;
    int s = seconds % 60;
    NSString *mString ;
    NSString *sString ;
    if (m<10)
    mString =[NSString stringWithFormat:@"%d",m];
    else
    mString =[NSString stringWithFormat:@"%d",m];
    
    if (s<10)
    sString =[NSString stringWithFormat:@"0%d",s];
    else
    sString =[NSString stringWithFormat:@"%d",s];
    
    return  [NSString stringWithFormat:@"%@:%@",mString,sString];
    
}

- (void)sliderValueChanged:(UISlider *)slider{
    double total = CMTimeGetSeconds(self.player.totalDuration);
    double currlentTime = total * slider.value;
    
    CMTime cTime = CMTimeMake(1 * currlentTime, 1);
    [self.player seekTo:cTime];
    
}

@end
