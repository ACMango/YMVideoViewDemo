//
//  YMVideoView.m
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/27.
//  Copyright © 2019 Mango. All rights reserved.
//

#import "YMVideoView.h"
#import "YBIBUtilities.h"
#import <AVFoundation/AVFoundation.h>

@interface YMVideoView ()

@property (strong, nonatomic) YMVideoTopBar *topBar;
@property (strong, nonatomic) YMVideoActionBar *actionBar;
@property (strong, nonatomic) UIButton *playButton;

@end

@implementation YMVideoView
{
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
    AVPlayerLayer *_playerLayer;
    BOOL _active;
}

#pragma mark - Life Cycle
- (void)dealloc {
    
    [self removeObserverForSystem];
    [self reset];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initValue];
        self.backgroundColor = UIColor.clearColor;
        
        [self addSubview:self.thumbImageView];
        [self addSubview:self.topBar];
        [self addSubview:self.actionBar];
        [self addSubview:self.playButton];
        [self addObserverForSystem];
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGesture:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)initValue {
    _playing = NO;
    _active = YES;
    _needAutoPlay = NO;
    _playFailed = NO;
    _preparingPlay = NO;
}

#pragma mark - public methods
// 手机方向发生变化
- (void)updateLayoutWithExpectOrientation:(UIDeviceOrientation)orientation containerSize:(CGSize)containerSize {
    
//    UIEdgeInsets padding = YBIBPaddingByBrowserOrientation(orientation);
    UIEdgeInsets padding = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        padding =  UIApplication.sharedApplication.delegate.window.safeAreaInsets;
    }
    
    CGFloat width = containerSize.width - padding.left - padding.right, height = containerSize.height;
    self.topBar.frame = CGRectMake(padding.left, padding.top, width, [YMVideoTopBar defaultHeight]);
    self.actionBar.frame = CGRectMake(padding.left, height - [YMVideoActionBar defaultHeight] - padding.bottom - 10, width, [YMVideoActionBar defaultHeight]);
    self.playButton.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    _playerLayer.frame = (CGRect){CGPointZero, containerSize};
    
}

- (void)reset {
    
    [self removeObserverForPlayer];
    
    [_player pause];
    _playerItem = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    
    [self finishPlay];
}

- (void)hideToolBar:(BOOL)hide {
    
    if (hide) {
        self.actionBar.hidden = YES;
        self.topBar.hidden = YES;
    } else {
        self.actionBar.hidden = NO;
        self.topBar.hidden = NO;
    }
}

- (void)hidePlayButton {
    
    self.playButton.hidden = YES;
}

#pragma mark - private
- (void)videoJumpWithScale:(float)scale {
    
    CMTime startTime = CMTimeMakeWithSeconds(scale, _player.currentTime.timescale);
    AVPlayer *tmpPlayer = _player;
    
    if (CMTIME_IS_INDEFINITE(startTime) || CMTIME_IS_INVALID(startTime)) return;
    
    [_player seekToTime:startTime toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000) completionHandler:^(BOOL finished) {
        
        if (finished && tmpPlayer == self->_player) {
            [self startPlay];
        }
    }];
}

- (void)preparPlay {
    
    if (!self.urlString) { // 播放资源不存在
        return;
    }
    
    _preparingPlay = YES;
    _playFailed = NO;
    
    self.playButton.hidden = YES;
    
    if (!_playerLayer) {
        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.urlString]];
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        [self.layer insertSublayer:_playerLayer above:self.thumbImageView.layer];
        
        [self addObserverForPlayer];
    } else {
        
        [self videoJumpWithScale:0];
    }
}

- (void)startPlay {
    if (_player) {
        _playing = YES;
        
        [_player play];
        [self.actionBar play];
        
        self.topBar.hidden = NO;
        self.actionBar.hidden = NO;
        
        [self.delegate ym_startPlayForVideoView:self];
    }
}

- (void)finishPlay {
    self.playButton.hidden = NO;
    [self.actionBar setCurrentValue:0];
    self.actionBar.hidden = YES;
    self.topBar.hidden = NO;
    
    _playing = NO;
    
    [self.delegate ym_finishPlayForVideoView:self];
}

- (void)playerPause {
    if (_player) {
        [_player pause];
        [self.actionBar pause];
    }
}

#pragma mark - observe
- (void)addObserverForPlayer {
    
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    __weak typeof(self) wSelf = self;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(wSelf) self = wSelf;
        if (!self) return;
        float currentTime = time.value / time.timescale;
        [self.actionBar setCurrentValue:currentTime];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

- (void)removeObserverForPlayer {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![self.delegate ym_isFreezingForVideoView:self]) {
        if (object == _playerItem) {
            if ([keyPath isEqualToString:@"status"]) {
                [self playerItemStatusChanged];
            }
        }
    }
}

- (void)didPlayToEndTime:(NSNotification *)noti {
    if (noti.object == _playerItem) {
        [self finishPlay];
        [self.delegate ym_didPlayToEndTimeForVideoView:self];
    }
}

- (void)playerItemStatusChanged {
    if (!_active) return;
    
    _preparingPlay = NO;
    
    switch (_playerItem.status) {
        case AVPlayerItemStatusReadyToPlay: {
            // Delay to update UI.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startPlay];
                double max = CMTimeGetSeconds(self->_playerItem.duration);
                [self.actionBar setMaxValue:(isnan(max) || isinf(max)) ? 0 : max];
            });
        }
            break;
        case AVPlayerItemStatusUnknown: {
            _playFailed = YES;
            [self.delegate ym_playFailedForVideoView:self];
            [self reset];
        }
            break;
        case AVPlayerItemStatusFailed: {
            _playFailed = YES;
            [self.delegate ym_playFailedForVideoView:self];
            [self reset];
        }
            break;
    }
}

- (void)removeObserverForSystem {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)addObserverForSystem {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil]; // 耳机状态获取的通知
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    _active = NO;
    [self playerPause];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    _active = YES;
}

- (void)didChangeStatusBarFrame {
//    if ([UIApplication sharedApplication].statusBarFrame.size.height > YBIBStatusbarHeight()) {
//        [self playerPause];
//    }
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSDictionary *interuptionDict = notification.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
                //拔出耳机时的处理为开启扬声器播放
                [self playerPause];
                break;
        }
    });
}

#pragma mark - event

- (void)respondsToTapGesture:(UITapGestureRecognizer *)tap {
    if (self.isPlaying) {
        self.actionBar.hidden = !self.actionBar.isHidden;
        self.topBar.hidden = !self.topBar.isHidden;
    } else {
        [self.delegate ym_respondsToTapGestureForVideoView:self];
    }
}

- (void)clickCancelButton:(UIButton *)button {
    [self.delegate ym_cancelledForVideoView:self];
}

- (void)clickPlayButton:(UIButton *)button {
    [self preparPlay];
}

#pragma mark - getters & setters
- (YMVideoTopBar *)topBar {
    if (!_topBar) {
        _topBar = [YMVideoTopBar new];
        [_topBar.cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        _topBar.hidden = YES;
    }
    return _topBar;
}

- (YMVideoActionBar *)actionBar {
    if (!_actionBar) {
        _actionBar = [YMVideoActionBar new];
        _actionBar.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        _actionBar.clickPlayBtnBlock = ^(UIButton * _Nonnull playBtn) {
            [weakSelf startPlay];
        };
        _actionBar.clickPauseBtnBlock = ^(UIButton * _Nonnull pauseBtn) {
            [weakSelf playerPause];
        };
        _actionBar.changeValueBlock = ^(CGFloat value) {
            [weakSelf videoJumpWithScale:value];
        };
    }
    return _actionBar;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.bounds = CGRectMake(0, 0, 100, 100);
        [_playButton setImage:[UIImage imageNamed:@"ymvv_bigPlay"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.hidden = YES;
        _playButton.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _playButton.layer.shadowOffset = CGSizeMake(0, 1);
        _playButton.layer.shadowOpacity = 1;
        _playButton.layer.shadowRadius = 4;
    }
    return _playButton;
}

- (UIImageView *)thumbImageView {
    if (!_thumbImageView) {
        _thumbImageView = [UIImageView new];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbImageView.layer.masksToBounds = YES;
    }
    return _thumbImageView;
}

- (void)setUrlString:(NSString *)urlString {
    
    _urlString = urlString;
    if (urlString) {
        self.playButton.hidden = NO;
    }
}


@end
