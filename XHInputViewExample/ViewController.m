//
//  ViewController.m
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 it7090.com. All rights reserved.
//

#import "ViewController.h"
#import "XHInputView.h"

@interface ViewController ()<XHInputViewDelagete>

@property (weak, nonatomic) IBOutlet UILabel *textLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Action
- (IBAction)showStyleDefault:(UIButton *)sender {
    
    [self showXHInputViewWithStyle:InputViewStyleDefault];//显示样式一
}

- (IBAction)showStyleLarge:(UIButton *)sender {
    
     [self showXHInputViewWithStyle:InputViewStyleLarge];//显示样式二
    
}

-(void)showXHInputViewWithStyle:(InputViewStyle)style{
    
    [XHInputView showWithStyle:style configurationBlock:^(XHInputView *inputView) {
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
            NSLog(@"输入的信息为:%@",text);
            _textLab.text = text;
            return YES;//return YES,收起键盘
        }else{
            NSLog(@"显示提示框-请输入要评论的的内容");
            return NO;//return NO,不收键盘
        }
    }];
    
}

#pragma mark - XHInputViewDelagete
/** XHInputView 将要显示 */
-(void)xhInputViewWillShow:(XHInputView *)inputView{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
