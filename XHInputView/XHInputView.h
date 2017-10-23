//
//  XHInputView.h
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InputViewStyle) {
    InputViewStyleDefault,
    InputViewStyleLarge,
};

@interface XHInputView : UIView

/** 最大输入字数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 字体 */
@property (nonatomic, strong) UIFont * font;
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 输入框背景颜色 */
@property (nonatomic, strong) UIColor* textViewBackgroundColor;
/** 发送按钮背景色 */
@property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
/** 发送按钮Title */
@property (nonatomic, copy) NSString *sendButtonTitle;
/** 发送按钮圆角大小 */
@property (nonatomic, assign) CGFloat sendButtonCornerRadius;
/** 发送按钮字体 */
@property (nonatomic, strong) UIFont * sendButtonFont;
/** 发送按钮点击回调 */
@property (nonatomic, copy) void(^sendBlcok)(NSString *text);

/** 初始化方法 */
- (instancetype)initWithStyle:(InputViewStyle)style;
/** 显示输入框 */
-(void)show;
/** 隐藏输入框 */
-(void)hide;

@end
