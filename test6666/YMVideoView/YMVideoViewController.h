//
//  YMVideoViewController.h
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/31.
//  Copyright © 2019 Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMVideoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMVideoViewController : UIViewController

@property (strong, nonatomic) NSString *urlString;

- (void)showFromViewController:(UIViewController *)contanierVC;

@end

NS_ASSUME_NONNULL_END
