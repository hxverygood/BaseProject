//
//  BaseTextView.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "BaseTextView.h"

@interface BaseTextView () <UITextViewDelegate>

@end



@implementation BaseTextView

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = MAIN_COLOR;
        self.font = [UIFont systemFontOfSize:15.0];
//        self.textContainerInset = UIEdgeInsetsZero;
//        self.textContainer.lineFragmentPadding = 0;

        self.delegate = self;
//        [self addObserver:self forKeyPath:@"contentSize" options: (NSKeyValueObservingOptionNew) context:NULL];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tintColor = MAIN_COLOR;
        self.font = [UIFont systemFontOfSize:15.0];
//        self.textContainerInset = UIEdgeInsetsZero;
//        self.textContainer.lineFragmentPadding = 0;

        self.delegate = self;
//        [self addObserver:self forKeyPath:@"contentSize" options: (NSKeyValueObservingOptionNew) context:NULL];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.tintColor = MAIN_COLOR;
}



//#pragma mark - KVO
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        UITextView *tv = object;
//        CGFloat diffSpace = ([tv bounds].size.height - [tv contentSize].height);
//        CGFloat inset = MAX(0, diffSpace/2.0);
//        tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);
//    }
//}



#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    // 文字垂直居中
    UITextView *tv = self;
    CGFloat diffSpace = ([tv bounds].size.height - [tv contentSize].height);
    CGFloat inset = MAX(0, diffSpace/2.0);
    tv.contentInset = UIEdgeInsetsMake(inset, tv.contentInset.left, inset, tv.contentInset.right);

    if ([self.base_delegate respondsToSelector:@selector(base_textViewDidChange:)]) {
        [self.base_delegate base_textViewDidChange:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.base_delegate respondsToSelector:@selector(base_textViewDidEndEditing:)]) {
        [self.base_delegate base_textViewDidEndEditing:textView];
    }
}



#pragma mark -

- (void)dealloc {
    self.delegate = nil;
}

@end
