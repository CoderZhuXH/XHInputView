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
    InputViewStyleBig,
};

@interface XHInputView : UIView

/** 发送按钮点击回调 */
@property (nonatomic, copy) void(^sendBlcok)(NSString *text);

/** 最大输入字数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 字体 */
@property (nonatomic, strong) UIFont * font;
/** 输入框背景颜色 */
@property (nonatomic, strong) UIColor* textViewBackgroundColor;

/** 显示输入框 */
-(void)show;

@end
