//
//  NoDataView.m
//

#import "NoDataView.h"

float const width_view  = 275.0;
float const height_view = 236.0;

@interface NoDataView ()

@property (nonatomic, copy) ReloadButtonClickBlock reloadButtonClickBlock ;
@property (nonatomic, strong) UIImageView *noDataImageView;

@end



@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.reloadButtonClickBlock = reloadBlock ;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews] ;
    
    CGRect rectNoData = CGRectZero ;
    rectNoData.size = CGSizeMake(width_view, height_view) ;
    rectNoData.origin.x = (self.frame.size.width - width_view)/2.0;
    rectNoData.origin.y = (self.frame.size.height - height_view)/2.0-49.0;
    self.noDataImageView.frame = rectNoData ;
}

- (void)showInView:(UIView *)viewWillShow {
    [viewWillShow addSubview:self] ;
}

- (void)dismiss {
    [self removeFromSuperview] ;
}



#pragma mark - Getter

- (UIImageView *)noDataImageView {
    if (!_noDataImageView) {
        _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]] ;
        _noDataImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (![_noDataImageView superview]) {
            [self addSubview:_noDataImageView] ;
        }
    }
    return _noDataImageView;
}

@end
