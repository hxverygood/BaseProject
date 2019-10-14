//
//  NoDataView.h
//

#import <UIKit/UIKit.h>

typedef void(^ReloadButtonClickBlock)(void) ;

@interface NoDataView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  reloadBlock:(ReloadButtonClickBlock)reloadBlock;

- (void)showInView:(UIView *)viewWillShow ;
- (void)dismiss ;

@end
