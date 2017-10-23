//
//  ViewController.m
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "ViewController.h"
#import "XHInputView.h"

@interface ViewController ()

@property (nonatomic, strong) XHInputView *inputViewStyleDefault;
@property (nonatomic, strong) XHInputView *inputViewStyleLarge;
@property (weak, nonatomic) IBOutlet UILabel *textLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     __weak typeof(self) weakSelf = self;
    
    //样式一
     self.inputViewStyleDefault = [self inputViewWithStyle:InputViewStyleDefault];
    [self.view addSubview:self.inputViewStyleDefault];
    self.inputViewStyleDefault.sendBlcok = ^(NSString *text) {
        [weakSelf.inputViewStyleDefault hide];//隐藏输入框
        weakSelf.textLab.text = text;
    };
    
    //样式二
    self.inputViewStyleLarge = [self inputViewWithStyle:InputViewStyleLarge];
    [self.view addSubview:self.inputViewStyleLarge];
    self.inputViewStyleLarge.sendBlcok = ^(NSString *text) {
        [weakSelf.inputViewStyleLarge hide];//隐藏输入框
        weakSelf.textLab.text = text;
    };
    
}


-(XHInputView *)inputViewWithStyle:(InputViewStyle)style{
    
    XHInputView *inputView = [[XHInputView alloc] initWithStyle:style];
    //设置最大输入字数
    inputView.maxCount = 50;
    //输入框颜色
    inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
    //占位符
    inputView.placeholder = @"请输入...";
    return inputView;
    
    
    //XHInputView 支持一下属性设置,详见XHInputView.h文件
    
//    /** 最大输入字数 */
//    @property (nonatomic, assign) NSInteger maxCount;
//    /** 字体 */
//    @property (nonatomic, strong) UIFont * font;
//    /** 占位符 */
//    @property (nonatomic, copy) NSString *placeholder;
//    /** 占位符颜色 */
//    @property (nonatomic, strong) UIColor *placeholderColor;
//    /** 输入框背景颜色 */
//    @property (nonatomic, strong) UIColor* textViewBackgroundColor;
//    /** 发送按钮背景色 */
//    @property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
//    /** 发送按钮Title */
//    @property (nonatomic, copy) NSString *sendButtonTitle;
//    /** 发送按钮圆角大小 */
//    @property (nonatomic, assign) CGFloat sendButtonCornerRadius;
//    /** 发送按钮字体 */
//    @property (nonatomic, strong) UIFont * sendButtonFont;
    
}

- (IBAction)showStyleDefault:(UIButton *)sender {
    
    [self.inputViewStyleDefault show];//显示样式一
}

- (IBAction)showStyleLarge:(UIButton *)sender {
    
    [self.inputViewStyleLarge show];//显示样式二
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
