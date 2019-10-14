//
//  NoDataCustomeView.m
//

#import "NoDataCustomeView.h"

static float const imageView_width  = 80.0;
static float const imageView_height = 80.0;
static float const imageView_label_spacing = 30.0;
static float const fontSize = 16.0;

#define LabelFontMainColor [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1.0]
#define LabelFontSecondaryColor [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]

@interface NoDataCustomeView ()

@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataLabel;
//@property (nonatomic, copy) ReloadButtonClickBlock reloadButtonClickBlock;

//@property (nonatomic, assign) BOOL isUserContent;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageName;

@end



@implementation NoDataCustomeView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                      content:(NSString *)content {
    self = [super initWithFrame:frame];
    if (self) {
        self.content = content;
        self.imageName = imageName;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;

    // 计算imageView的Frame
    CGRect imageViewNoDataRect = CGRectZero;
    imageViewNoDataRect.size = CGSizeMake(imageView_width, imageView_height);
    imageViewNoDataRect.origin.x = (viewWidth - imageView_width)/2.0;

    // 计算label的frame
    CGRect noDataLabelRect = CGRectZero;
    if (_content.length > 0) {
        // 如果包含换行符，则第1行文字颜色是不同的
        if ([_content containsString:@"\n"]) {
            NSRange range = [_content rangeOfString:@"\n"];
            NSMutableAttributedString *attrStr = [self attributedWithString:_content fromIndex:0 toIndex:range.location-1 size:fontSize otherSize:fontSize-2 color:LabelFontMainColor otherColor:LabelFontSecondaryColor lineHeight:8.0];
            self.noDataLabel.attributedText = attrStr;
        }

        CGFloat x = 10.0;

        noDataLabelRect.origin.x = 10.0;
        noDataLabelRect.size.width = (viewWidth - x * 2);
        noDataLabelRect.size.height = [self.noDataLabel sizeThatFits:CGSizeMake(noDataLabelRect.size.width, CGFLOAT_MAX)].height;
    }

    // 计算label和image组合所形成区域的高度，以此确定imageView和lable的Y值
    CGFloat tipsContainerHeight = imageViewNoDataRect.size.height + imageView_label_spacing + noDataLabelRect.size.height;
    CGFloat tipsContainerY = (viewHeight - tipsContainerHeight) / 2;
    // 为了视觉效果，再向上偏移30
    imageViewNoDataRect.origin.y = tipsContainerY - 30.0;
    noDataLabelRect.origin.y = imageViewNoDataRect.origin.y + imageViewNoDataRect.size.height + imageView_label_spacing;

    self.noDataImageView.frame = imageViewNoDataRect;
    self.noDataLabel.frame = noDataLabelRect;
}



#pragma mark - Getter

- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] init];
        _noDataImageView.image = [self isBlankString:_imageName] ? nil : [UIImage imageNamed:_imageName];
        _noDataImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (![_noDataImageView superview]) {
            [self addSubview:_noDataImageView];
        }
    }
    return _noDataImageView;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        if (self.content) {
            _noDataLabel.text = _content;
        } else {
            _noDataLabel.text =  @"暂无数据";
        }
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _noDataLabel.font = [UIFont systemFontOfSize:fontSize];
        _noDataLabel.numberOfLines = 0;
        if (![_noDataLabel superview]) {
            [self addSubview:_noDataLabel];
        }
    }
    return _noDataLabel;
}


#pragma mark - Private Func

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (NSMutableAttributedString *)attributedWithString:(NSString *)string
                                   fromIndex:(NSInteger)from
                                     toIndex:(NSInteger)to
                                        size:(CGFloat)fontSize
                                   otherSize:(CGFloat)otherFontSize
                                       color:(UIColor *)color
                                  otherColor:(UIColor *)otherColor
                                  lineHeight:(CGFloat)lineHeight {

    NSInteger length = string.length;
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range;
    if (from != 0) {
        range = NSMakeRange(0, from);
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherFontSize] range:range];
        [mutStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range];
    }

    range = NSMakeRange(from, to - from + 1);
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    [mutStr addAttribute:NSForegroundColorAttributeName value:color range:range];

    if (to != (length - 1)) {
        range = NSMakeRange(to + 1, length - 1 - to);
        [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:otherFontSize] range:range];
        [mutStr addAttribute:NSForegroundColorAttributeName value:otherColor range:range];
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineHeight > 0 ? lineHeight : paragraphStyle.minimumLineHeight];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSRange paragraphRange = NSMakeRange(0, string.length);
    [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:paragraphRange];


    return mutStr;
}

@end
