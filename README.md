
## 轻量级评论输入框,支持多种样式,支持占位符设置等等!

[![AppVeyor](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg?maxAge=2592000)](https://github.com/CoderZhuXH/XHInputView)
[![Version Status](https://img.shields.io/cocoapods/v/XHInputView.svg?style=flat)](http://cocoadocs.org/docsets/XHInputView)
[![Support](https://img.shields.io/badge/support-iOS%207%2B-brightgreen.svg)](https://github.com/CoderZhuXH/XHInputView)
[![Pod Platform](https://img.shields.io/cocoapods/p/XHInputView.svg?style=flat)](http://cocoadocs.org/docsets/XHInputView/)
[![Pod License](https://img.shields.io/cocoapods/l/XHInputView.svg?style=flat)](https://github.com/CoderZhuXH/XHInputView/blob/master/LICENSE)


### 技术交流群(群号:537476189)


## 效果


![image](https://github.com/CoderZhuXH/XHInputView/blob/master/ScreenShot/样式一.png) ![image](https://github.com/CoderZhuXH/XHInputView/blob/master/ScreenShot/样式二.png)


## 使用方法

###   显示输入框

```objc


    //支持InputViewStyleDefault 与 InputViewStyleLarge 两种样式
    [XHInputView showWithStyle:InputViewStyleDefault configurationBlock:^(XHInputView *inputView) {
        /** 请在此block中设置inputView属性 */
        
        /** 代理 */
        inputView.delegate = self;
        
        /** 占位符文字 */
        inputView.placeholder = @"请输入评论文字...";
        /** 设置最大输入字数 */
        inputView.maxCount = 50;
        /** 输入框颜色 */
        inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
        
        /** 更多属性设置,详见XHInputView.h文件 */
        
    } sendBlock:^BOOL(NSString *text) {

        if(text.length){
            NSLog(@"输入为信息为:%@",text);
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-你输入的内容为空");
            return NO;//return NO,不收键盘
        }
    }];

```


###   代理方法<XHInputViewDelagete>

```objc

/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView
{
    
     /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要显示时将其关闭 */
    
     //[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
     //[IQKeyboardManager sharedManager].enable = NO;

}

/** XHInputView 将要影藏 */
-(void)xhInputViewWillHide:(XHInputView *)inputView{
    
     /** 如果你工程中有配置IQKeyboardManager,并对XHInputView造成影响,请在XHInputView将要影藏时将其打开 */
    
     //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
     //[IQKeyboardManager sharedManager].enable = YES;
}

```

###    更多属性设置

```objc

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

```
##  安装
### 1.手动添加:<br>
*   1.将 XHInputView 文件夹添加到工程目录中<br>
*   2.导入 XHInputView.h

### 2.CocoaPods:<br>
*   1.在 Podfile 中添加 pod 'XHInputView'<br>
*   2.执行 pod install 或 pod update<br>
*   3.导入 XHInputView.h

##  系统要求
*   该项目最低支持 iOS 7.0 和 Xcode 7.0

##  许可证
XHInputView 使用 MIT 许可证，详情见 LICENSE 文件
