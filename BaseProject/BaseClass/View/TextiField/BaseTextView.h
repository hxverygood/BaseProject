//
//  BaseTextView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/8.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTextViewDelegate <NSObject>

@optional
- (void)base_textViewDidChange:(UITextView *)textView;
- (void)base_textViewDidEndEditing:(UITextView *)textView;

@end

@interface BaseTextView : UITextView

@property (nonatomic, weak) id<BaseTextViewDelegate> base_delegate;

@end
