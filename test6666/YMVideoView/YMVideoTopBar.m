//
//  YMVideoTopBar.m
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/27.
//  Copyright © 2019 Mango. All rights reserved.
//

#import "YMVideoTopBar.h"

@interface YMVideoTopBar ()

@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation YMVideoTopBar

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cancelButton];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat buttonWidth = 54.0;
    self.cancelButton.frame = CGRectMake(0, 0, buttonWidth, self.bounds.size.height);
}


#pragma mark - Public Methods
+ (CGFloat)defaultHeight {
    
    return 50.0;
}

#pragma mark - setter && getter
- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"ymvv_cancel"] forState:UIControlStateNormal];
        _cancelButton.layer.shadowOffset = CGSizeMake(0, 1);
        _cancelButton.layer.shadowOpacity = 1;
        _cancelButton.layer.shadowRadius = 4;
    }
    return _cancelButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
