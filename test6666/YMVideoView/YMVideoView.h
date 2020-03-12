//
//  YMVideoView.h
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/27.
//  Copyright © 2019 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMVideoTopBar.h"
#import "YMVideoActionBar.h"

NS_ASSUME_NONNULL_BEGIN

@class YMVideoView;

@protocol YMVideoViewDelegate <NSObject>
@required

- (BOOL)ym_isFreezingForVideoView:(YMVideoView *)view;

- (void)ym_preparePlayForVideoView:(YMVideoView *)view;

- (void)ym_startPlayForVideoView:(YMVideoView *)view;

- (void)ym_finishPlayForVideoView:(YMVideoView *)view;

- (void)ym_didPlayToEndTimeForVideoView:(YMVideoView *)view;

- (void)ym_playFailedForVideoView:(YMVideoView *)view;

- (void)ym_respondsToTapGestureForVideoView:(YMVideoView *)view;

- (void)ym_cancelledForVideoView:(YMVideoView *)view;

- (CGSize)ym_containerSizeForVideoView:(YMVideoView *)view;

- (void)ym_autoPlayCountChanged:(NSUInteger)count;

@end


@interface YMVideoView : UIView

// status
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;
@property (nonatomic, assign, readonly, getter=isPlayFailed) BOOL playFailed;
@property (nonatomic, assign, readonly, getter=isPreparingPlay) BOOL preparingPlay;
@property (nonatomic, assign) BOOL needAutoPlay; // 默认为自动播放

// Data
@property (strong, nonatomic) NSString *urlString;
@property (weak, nonatomic) id<YMVideoViewDelegate> delegate;

// ui
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong, readonly) YMVideoTopBar *topBar;
@property (nonatomic, strong, readonly) YMVideoActionBar *actionBar;
@property (nonatomic, strong) UIImageView *loadingView;
// actions
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;

// methods
- (void)reset;

- (void)hideToolBar:(BOOL)hide;

- (void)hidePlayButton;

- (void)preparPlay;

- (void)updateLayoutWithExpectOrientation:(UIDeviceOrientation)orientation containerSize:(CGSize)containerSize;

@end

NS_ASSUME_NONNULL_END
