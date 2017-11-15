//
//  XHInputView.h
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHInputView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InputViewStyle) {
    InputViewStyleDefault,
    InputViewStyleLarge,
};

@class XHInputView;
@protocol XHInputViewDelagete <NSObject>
@optional

/**
//如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,
 请在XHInputView将要显示代理方法里 将IQKeyboardManager的enableAutoToolbar及enable属性 关闭
 请在XHInputView将要消失代理方法里 将IQKeyboardManager的enableAutoToolbar及enable属性 打开
 如下:
 
//XHInputView 将要显示
-(void)xhInputViewWillShow:(XHInputView *)inputView{
 [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
 [IQKeyboardManager sharedManager].enable = NO;
}

//XHInputView 将要影藏
-(void)xhInputViewWillHide:(XHInputView *)inputView{
     [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
     [IQKeyboardManager sharedManager].enable = YES;
}
*/

/**
 XHInputView 将要显示
 
 @param inputView inputView
 */
-(void)xhInputViewWillShow:(XHInputView *)inputView;

/**
 XHInputView 将要影藏

 @param inputView inputView
 */
-(void)xhInputViewWillHide:(XHInputView *)inputView;

@end

@interface XHInputView : UIView

@property (nonatomic, assign) id<XHInputViewDelagete> delegate;

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


/**
 显示输入框

 @param style 类型
 @param configurationBlock 请在此block中设置XHInputView属性
 @param sendBlock 发送按钮点击回调
 */
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(XHInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock;

@end
