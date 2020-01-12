//
//  YMVideoActionBar.m
//  UIShowVideoView
//
//  Created by SL设计 on 2019/12/27.
//  Copyright © 2019 Mango. All rights reserved.
//

#import "YMVideoActionBar.h"

#pragma mark - actionView的滑动块视图
@interface YMVideoBrowseActionSlider : UISlider
@end

@implementation YMVideoBrowseActionSlider

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setThumbImage:[UIImage imageNamed:@"ymvv_circlePoint"] forState:UIControlStateNormal];
        self.minimumTrackTintColor = UIColor.whiteColor;
        self.maximumTrackTintColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        self.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 4;
    }
    return self;
}

// 增加滑块条高度为2
- (CGRect)trackRectForBounds:(CGRect)bounds {
    
    CGRect frame = [super trackRectForBounds:bounds];
    return CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 2);
}

// 增加滑块触摸面积
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    CGRect frame = [super thumbRectForBounds:bounds trackRect:rect value:value];
    return CGRectMake(frame.origin.x - 10, frame.origin.y - 10, frame.size.width + 20, frame.size.height + 20);
}

@end


@interface YMVideoActionBar ()

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UILabel *preTimeLab;
@property (strong, nonatomic) UILabel *sufTimeLab;
@property (strong, nonatomic) YMVideoBrowseActionSlider *slider;

@end

@implementation YMVideoActionBar
{
    BOOL _dragging;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _dragging = NO;
        [self addSubview:self.playBtn];
        [self addSubview:self.preTimeLab];
        [self addSubview:self.sufTimeLab];
        [self addSubview:self.slider];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat width = self.bounds.size.width, height = self.bounds.size.height, labelwidth = 55.0, btnWidth = 44.0, labelOffset = 10.0;
    CGFloat imageWidth = [UIImage imageNamed:@"ymvv_play"].size.width;
    CGFloat offset = (btnWidth - imageWidth) * 0.5;
    
    self.playBtn.frame = CGRectMake(10, 0, btnWidth, height);
    self.preTimeLab.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame) + labelOffset - offset, 0, labelwidth, height);
    self.sufTimeLab.frame = CGRectMake(width - labelwidth - labelOffset, 0, labelwidth, height);
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.preTimeLab.frame), 0, CGRectGetMinX(self.sufTimeLab.frame) - CGRectGetMaxX(self.preTimeLab.frame), height);
}

#pragma mark - public
+ (CGFloat)defaultHeight {
    
    return 44.0;
}

- (void)setMaxValue:(float)value {
    
    self.slider.maximumValue = value;
    self.sufTimeLab.attributedText = [self.class timeformatFromSeconds:value];
}

- (void)setCurrentValue:(float)value {
    
    if (!_dragging) {
        [self.slider setValue:value animated:YES];
    }
    self.preTimeLab.attributedText = [self.class timeformatFromSeconds:value];
}

- (void)pause {
    
    self.playBtn.selected = NO;
}

- (void)play {
    
    _dragging = NO;
    self.playBtn.selected = YES;
    self.slider.userInteractionEnabled = YES;
}


#pragma mark - private
+ (NSAttributedString *)timeformatFromSeconds:(NSInteger)seconds {
    
    NSInteger hour = seconds / 3600, min = (seconds % 360) / 60, sec = seconds % 60;
    NSString *text = seconds > 3600 ? [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec] : [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    
    NSShadow *shadow = [NSShadow new];
    shadow.shadowBlurRadius = 4;
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowColor = UIColor.darkGrayColor;
    NSAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    return attr;
}

#pragma mark - touch event
- (void)clickPlayBtn:(UIButton *)button {
    button.userInteractionEnabled = NO;
    if (button.selected) {
        
        if (_clickPauseBtnBlock) {
            _clickPauseBtnBlock(button);
        }
    } else {
        
        if (_clickPlayBtnBlock) {
            _clickPlayBtnBlock(button);
        }
    }
    button.userInteractionEnabled = YES;
}

- (void)respondsToSliderTouchFinished:(UISlider *)slider {
 
    if (_changeValueBlock) {
        _changeValueBlock(slider.value);
    }
}

- (void)respondsToSliderTouchDown:(UISlider *)slider {
    _dragging = YES;
    slider.userInteractionEnabled = NO;
}

#pragma mark - getters
- (UIButton *)playBtn {
    
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"ymvv_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"ymvv_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _playBtn.layer.shadowColor = UIColor.darkGrayColor.CGColor;
        _playBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _playBtn.layer.shadowOpacity = 1;
        _playBtn.layer.shadowRadius = 4;
    }
    return _playBtn;
}

- (UILabel *)preTimeLab {
    
    if (!_preTimeLab) {
        _preTimeLab = [UILabel new];
        _preTimeLab.attributedText = [self.class timeformatFromSeconds:0];
        _preTimeLab.adjustsFontSizeToFitWidth = YES;
        _preTimeLab.textAlignment = NSTextAlignmentCenter;
        _preTimeLab.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
    }
    
    return _preTimeLab;
}

- (UILabel *)sufTimeLab {
    
    if (!_sufTimeLab) {
        _sufTimeLab = [UILabel new];
        _sufTimeLab.attributedText = [self.class timeformatFromSeconds:0];
        _sufTimeLab.adjustsFontSizeToFitWidth = YES;
        _sufTimeLab.textAlignment = NSTextAlignmentCenter;
        _sufTimeLab.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
    }
    return _sufTimeLab;
}

- (YMVideoBrowseActionSlider *)slider {
    
    if (!_slider) {
        _slider = [YMVideoBrowseActionSlider new];
        [_slider addTarget:self action:@selector(respondsToSliderTouchFinished:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(respondsToSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _slider;
}

- (BOOL)isTouchInside {
    return self.slider.isTouchInside;
}

@end
