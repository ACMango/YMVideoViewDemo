//
//  YMVideoBrowser.m
//  test6666
//
//  Created by SL设计 on 2020/1/2.
//  Copyright © 2020 Mango. All rights reserved.
//

#import "YMVideoBrowser.h"

@interface YMVideoBrowser ()<YMVideoViewDelegate>

@property (strong, nonatomic) YMVideoView *videoView;

@end

@implementation YMVideoBrowser

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.blackColor;
        [self addSubview:self.videoView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.videoView.frame = self.bounds;
}

#pragma mark - public
- (void)show {
    [self showToView:[UIApplication sharedApplication].keyWindow];
}

- (void)showToView:(UIView *)view {
    [self showToView:view containerSize:view.bounds.size];
}

- (void)showToView:(UIView *)view containerSize:(CGSize)containerSize {
//    [self.rotationHandler startObserveStatusBarOrientation];
    
    [view addSubview:self];
    self.frame = view.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    _originStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
//
//    [self.rotationHandler configContainerSize:containerSize];
    
    __kindof UIView *startView;
    UIImage *startImage;
    CGRect endFrame = CGRectZero;
    id<YBIBDataProtocol> data = [self.dataMediator dataForCellAtIndex:self.currentPage];
    if ([data respondsToSelector:@selector(yb_projectiveView)]) {
        startView = data.yb_projectiveView;
        self.hiddenProjectiveView = startView;
        if ([startView isKindOfClass:UIImageView.class]) {
            startImage = ((UIImageView *)startView).image;
        } else {
            startImage = YBIBSnapshotView(startView);
        }
    }
    if ([data respondsToSelector:@selector(yb_imageViewFrameWithContainerSize:imageSize:orientation:)]) {
        endFrame = [data yb_imageViewFrameWithContainerSize:self.bounds.size imageSize:startImage.size orientation:self.rotationHandler.currentOrientation];
    }
    
    [self setTransitioning:YES isShow:YES];
    [self.animatedTransition yb_showTransitioningWithContainer:self startView:startView startImage:startImage endFrame:endFrame orientation:self.rotationHandler.currentOrientation completion:^{
        [self hideStatusBar];
        [self build];
        [self setTransitioning:NO isShow:YES];
    }];
}

- (void)hide {
    __kindof UIView *startView;
    __kindof UIView *endView;
    UICollectionViewCell<YBIBCellProtocol> *cell = (UICollectionViewCell<YBIBCellProtocol> *)self.collectionView.centerCell;
    if ([cell respondsToSelector:@selector(yb_foregroundView)]) {
        startView = cell.yb_foregroundView;
    }
    if ([cell.yb_cellData respondsToSelector:@selector(yb_projectiveView)]) {
        endView = cell.yb_cellData.yb_projectiveView;
    }
    
    for (id<YBIBToolViewHandler> handler in self.toolViewHandlers) {
        [handler yb_hide:YES];
    }
    [self showStatusBar];
    
    [self setTransitioning:YES isShow:NO];
    [self.animatedTransition yb_hideTransitioningWithContainer:self startView:startView endView:endView orientation:self.rotationHandler.currentOrientation completion:^{
        [self rebuild];
        [self removeFromSuperview];
        [self setTransitioning:NO isShow:NO];
    }];
}

#pragma mark - getter && setter
- (YMVideoView *)videoView {
    
    if (!_videoView) {
        
        _videoView = [YMVideoView new];
        _videoView.delegate = self;
    }
    return _videoView;
}

@end
