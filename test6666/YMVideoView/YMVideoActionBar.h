//
//  YMVideoActionBar.h
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/27.
//  Copyright © 2019 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YMVideoActionBar;

@interface YMVideoActionBar : UIView

// block(require)
@property (copy, nonatomic) void(^clickPlayBtnBlock)(UIButton *playBtn);
@property (copy, nonatomic) void(^clickPauseBtnBlock)(UIButton *pauseBtn);
@property (copy, nonatomic) void(^changeValueBlock)(CGFloat value);

@property (nonatomic, assign, readonly) BOOL isTouchInside;

- (void)setMaxValue:(float)value;
- (void)setCurrentValue:(float)value;
- (void)pause;
- (void)play;

+ (CGFloat)defaultHeight;

@end

NS_ASSUME_NONNULL_END

