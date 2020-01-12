//
//  YMVideoTopBar.h
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/27.
//  Copyright © 2019 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMVideoTopBar : UIView

@property (strong, nonatomic, readonly) UIButton *cancelButton;

// 默认高度
+ (CGFloat)defaultHeight;

@end

NS_ASSUME_NONNULL_END
