//
//  DashLineView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/26.
//  Copyright © 2018年 lightingdog. All rights reserved.
//



#import "DashLineView.h"

static CGFloat lineLength = 3.0;
static CGFloat lineSpacing = 3.0;


@interface DashLineView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIColor *defaultLineColor;

@end



@implementation DashLineView

#pragma mark - Getter

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
    }
    return _shapeLayer;
}

- (UIColor *)defaultLineColor {
    if (!_defaultLineColor) {
        _defaultLineColor = [UIColor colorWithRed:226/255.0 green:226/255.0  blue:226/255.0  alpha:1.0];
    }
    return _defaultLineColor;
}



#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    /// view的frame随约束变化后才绘制虚线
    CGFloat length = (_lineLength != 0) ? _lineLength : lineLength;
    CGFloat spacing = (_lineSpacing != 0) ? _lineSpacing : lineSpacing;
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);

    if (_direction) {
        [self drawDashLineWithLineLength:length lineSpacing:spacing lineColor:_lineColor ? : self.defaultLineColor direction:_direction];
    }
    else {
        if (viewWidth > viewHeight) {
            [self drawDashLineWithLineLength:length lineSpacing:spacing lineColor:_lineColor ? : self.defaultLineColor direction:DashDirectionTypeHorizontal];
        }
        else {
            [self drawDashLineWithLineLength:length lineSpacing:spacing lineColor:_lineColor ? : self.defaultLineColor direction:DashDirectionTypeVertical];
        }
    }
}



#pragma mark - Private Func

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 **/
- (void)drawDashLineWithLineLength:(int)lineLength
                       lineSpacing:(int)lineSpacing
                         lineColor:(UIColor *)lineColor
                         direction:(DashDirectionType)direction {
    CGRect frame = self.frame;
    self.backgroundColor = [UIColor clearColor];

    BOOL exist = NO;
    exist = _shapeLayer != nil ? YES : NO;

//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [self.shapeLayer setBounds:self.bounds];

    switch (direction) {
        case DashDirectionTypeHorizontal:
        {
            // 设置锚点
            [self.shapeLayer setPosition:CGPointMake(CGRectGetWidth(frame) / 2, CGRectGetHeight(frame))];
            // 设置虚线宽度
            [self.shapeLayer setLineWidth:CGRectGetHeight(frame)];
        }
            break;

        case DashDirectionTypeVertical:
        {
            // 设置锚点
            [self.shapeLayer setPosition:CGPointMake(CGRectGetWidth(frame), CGRectGetHeight(frame) / 2)];
            // 设置虚线宽度
            [self.shapeLayer setLineWidth:CGRectGetWidth(frame)];
        }
            break;

        default:
            break;
    }

    [self.shapeLayer setFillColor:[UIColor clearColor].CGColor];
    // 设置虚线颜色Color
    [self.shapeLayer setStrokeColor:lineColor.CGColor];
    [self.shapeLayer setLineJoin:kCALineJoinRound];
    // 设置线宽，线间距
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    // 设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);

    switch (direction) {
        case DashDirectionTypeHorizontal:
        {
            CGPathAddLineToPoint(path, NULL, CGRectGetWidth(frame), 0);
        }
            break;

        case DashDirectionTypeVertical:
        {
            CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(frame));
        }
            break;

        default:
            break;
    }

    [self.shapeLayer setPath:path];
    CGPathRelease(path);

    [self.layer addSublayer:self.shapeLayer];

//    // 如果还没有添加，则把绘制好的虚线添加上来
//    if (exist == NO) {
//        [self.layer addSublayer:self.shapeLayer];
//    }
}

@end
