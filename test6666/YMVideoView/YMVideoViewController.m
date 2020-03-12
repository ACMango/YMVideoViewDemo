//
//  YMVideoViewController.m
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/31.
//  Copyright © 2019 Mango. All rights reserved.
//

#import "YMVideoViewController.h"

@interface YMVideoViewController ()<YMVideoViewDelegate>

@property (strong, nonatomic) YMVideoView *videoView;

@end

@implementation YMVideoViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.blackColor;
    // 设置videoView
    YMVideoView *videoView = [[YMVideoView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    videoView.delegate = self;
    [self.view addSubview:videoView];
    self.videoView = videoView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.urlString) {
        
        self.videoView.urlString = self.urlString;
        [self.videoView updateLayoutWithExpectOrientation:UIDeviceOrientationPortrait containerSize:self.view.bounds.size];
        [self.videoView preparPlay];
    } else {
        
        NSAssert(0, @"urlString 为空，不能播放");
    }
}

- (void)dealloc {
    
    NSLog(@"videoViewController 已经移除了");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - public Methods
- (void)showFromViewController:(UIViewController *)contanierVC {
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [contanierVC presentViewController:self animated:YES completion:^{
    }];
}

#pragma mark - private Methods
// 屏幕改变时
- (void)orientationChanged {

    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    switch ([[UIDevice currentDevice] orientation]) {

        case UIDeviceOrientationPortrait:

        {
            NSLog(@"portrait");
            [self.videoView updateLayoutWithExpectOrientation:UIDeviceOrientationPortrait containerSize:CGSizeMake(width, height)];
        }
            
            break;

        case UIDeviceOrientationPortraitUpsideDown:

            NSLog(@"portraitUpSideDown");
            break;

        case UIDeviceOrientationLandscapeLeft:
            
        {
            NSLog(@"landscapeLeft");
            [self.videoView updateLayoutWithExpectOrientation:UIDeviceOrientationLandscapeLeft containerSize:CGSizeMake(width, height)];
        }
            break;

        case UIDeviceOrientationLandscapeRight:

        {
            NSLog(@"landscapeRight");
            [self.videoView updateLayoutWithExpectOrientation:UIDeviceOrientationLandscapeRight containerSize:CGSizeMake(width, height)];
        }
            break;

        case UIDeviceOrientationFaceDown:
            NSLog(@"facedown!!");
            break;

        case UIDeviceOrientationFaceUp:

            NSLog(@"FaceUp");
            break;
        default:
            break;

        }
}

#pragma mark - <YBIBVideoViewDelegate>

- (BOOL)ym_isFreezingForVideoView:(YMVideoView *)view {
    return NO;
}

- (void)yb_preparePlayForVideoView:(YMVideoView *)view {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (!view.isPlaying && !view.isPlayFailed && self.yb_selfPage() == self.yb_currentPage()) {
//            [self.yb_auxiliaryViewHandler() yb_showLoadingWithContainer:self];
//        }
//    });

}

- (void)ym_startPlayForVideoView:(YMVideoView *)view {
//    self.videoView.thumbImageView.hidden = YES;
//    [self.yb_backView ybib_videoPlayingAdd:self];
//    [self.yb_auxiliaryViewHandler() yb_hideLoadingWithContainer:self];
//    [self hideToolViews:YES];

}

- (void)ym_didPlayToEndTimeForVideoView:(YMVideoView *)view {
//    YBIBVideoData *data = (YBIBVideoData *)self.yb_cellData;
//    if (data.repeatPlayCount == NSUIntegerMax) {
//        [view preparPlay];
//    } else if (data.repeatPlayCount > 0) {
//        --data.repeatPlayCount;
//        [view preparPlay];
//    } else {
//        [self hideToolViews:NO];
//    }
}

- (void)ym_finishPlayForVideoView:(YMVideoView *)view {
//    [self.yb_backView ybib_videoPlayingRemove:self];
//    [self hideToolViews:NO];
}

- (void)ym_playFailedForVideoView:(YMVideoView *)view {
//    [self.yb_auxiliaryViewHandler() yb_hideLoadingWithContainer:self];
//    [self.yb_auxiliaryViewHandler() yb_showIncorrectToastWithContainer:self text:YBIBCopywriter.sharedCopywriter.videoError];
}

- (void)ym_respondsToTapGestureForVideoView:(YMVideoView *)view {
//    if (self.yb_isRotating()) return;
    
//    YBIBVideoData *data = self.yb_cellData;
//    if (data.singleTouchBlock) {
//        data.singleTouchBlock(data);
//    } else {
//        [self hideBrowser];
//    }
}

- (void)ym_cancelledForVideoView:(YMVideoView *)view {
//    if (self.yb_isRotating()) return;

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGSize)ym_containerSizeForVideoView:(YMVideoView *)view {
    return CGSizeMake(300, 500);
}

- (void)ym_autoPlayCountChanged:(NSUInteger)count {
//    YBIBVideoData *data = (YBIBVideoData *)self.yb_cellData;
//    data.autoPlayCount = count;
}

#pragma mark - Other
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - setter && getter

@end
