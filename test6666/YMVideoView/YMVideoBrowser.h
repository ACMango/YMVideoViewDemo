//
//  YMVideoBrowser.h
//  test6666
//
//  Created by SL设计 on 2020/1/2.
//  Copyright © 2020 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMVideoBrowser : UIView


@property (strong, nonatomic) NSString *urlString;

/// 是否正在转场
@property (nonatomic, assign, readonly, getter=isTransitioning) BOOL transitioning;
/// 是否正在进行展示过程转场
@property (nonatomic, assign, readonly, getter=isShowTransitioning) BOOL showTransitioning;
/// 是否正在进行隐藏过程转场
@property (nonatomic, assign, readonly, getter=isHideTransitioning) BOOL hideTransitioning;


/**
 展示

 @param view 指定父视图（view 的大小不能为 CGSizeZero，但允许变化）
 @param containerSize 容器大小（当 view 的大小允许变化时，必须指定确切的 containerSize）
 */
- (void)showToView:(UIView *)view containerSize:(CGSize)containerSize;
- (void)showToView:(UIView *)view;
- (void)show;

@end

NS_ASSUME_NONNULL_END
