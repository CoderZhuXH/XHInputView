//
//  XHInputView.m
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHInputView

#import "XHInputView.h"

#define XHInputView_ScreenW    [UIScreen mainScreen].bounds.size.width
#define XHInputView_ScreenH    [UIScreen mainScreen].bounds.size.height
#define XHInputView_StyleLarge_LRSpace 10
#define XHInputView_StyleLarge_TBSpace 8
#define XHInputView_StyleDefault_LRSpace 5
#define XHInputView_StyleDefault_TBSpace 5
#define XHInputView_CountLabHeight 20
#define XHInputView_BgViewColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

#define XHInputView_StyleLarge_Height 170
#define XHInputView_StyleDefault_Height 45

static CGFloat keyboardAnimationDuration = 0.5;

@interface XHInputView()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) InputViewStyle style;

@property (nonatomic, assign) CGRect showFrameDefault;
@property (nonatomic, assign) CGRect sendButtonFrameDefault;
@property (nonatomic, assign) CGRect textViewFrameDefault;

/** 发送按钮点击回调 */
@property (nonatomic, copy) BOOL(^sendBlcok)(NSString *text);

@end

@implementation XHInputView

-(void)dealloc{
    //NSLog(@"XHInputView 销毁");
    if(_style == InputViewStyleDefault){
        [_textView removeObserver:self forKeyPath:@"contentSize"];
    }
}
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(XHInputView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock{
    XHInputView *inputView = [[XHInputView alloc] initWithStyle:style];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:inputView];
    if(configurationBlock) configurationBlock(inputView);
    inputView.sendBlcok = [sendBlock copy];
    [inputView show];
}
#pragma mark - private
-(void)show{
    if([self.delegate respondsToSelector:@selector(xhInputViewWillShow:)]){
        [self.delegate xhInputViewWillShow:self];
    }
    _textView.text = nil;
    _placeholderLab.hidden = NO;
    
    if(_style == InputViewStyleLarge){
        if(_maxCount>0) _countLab.text = [NSString stringWithFormat:@"0/%ld",(long)_maxCount];
    }
    
    [_textView becomeFirstResponder];
}

-(void)hide{
    
    if([self.delegate respondsToSelector:@selector(xhInputViewWillHide:)]){
        [self.delegate xhInputViewWillHide:self];
    }
    [_textView resignFirstResponder];
}

- (instancetype)initWithStyle:(InputViewStyle)style
{
    self = [super init];
    if (self) {
        
        _style = style;
        /** 创建UI */
        [self  setupUI];
        /** 键盘监听 */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)setupUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _inputView = [[UIView alloc] init];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_inputView];
    
    switch (_style) {
        case InputViewStyleDefault:{
            
            _inputView.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, XHInputView_StyleDefault_Height);
            
            /** StyleDefaultUI */
            CGFloat sendButtonWidth = 45;
            CGFloat sendButtonHeight = _inputView.bounds.size.height -2*XHInputView_StyleDefault_TBSpace;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - sendButtonWidth, XHInputView_StyleDefault_TBSpace,sendButtonWidth, sendButtonHeight);
            [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_inputView addSubview:_sendButton];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace, XHInputView_ScreenW - 3*XHInputView_StyleDefault_LRSpace - sendButtonWidth, self.inputView.bounds.size.height-2*XHInputView_StyleDefault_TBSpace)];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            _textView.delegate = self;
            [_inputView addSubview:_textView];
            //KVO监听contentSize变化
            [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, _textView.bounds.size.height)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            _sendButtonFrameDefault = _sendButton.frame;
            _textViewFrameDefault = _textView.frame;
            
        }
            break;
        case InputViewStyleLarge:{
            
            CGFloat height = 170;
            if(XHInputView_ScreenH<=320){
                height = 90;
            }else if(XHInputView_ScreenH<=375){
                height = 140;
            }
            _inputView.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, height);
            
            /** StyleLargeUI */
            CGFloat sendButtonWidth = 58;
            CGFloat sendButtonHeight = 29;
            _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleLarge_LRSpace - sendButtonWidth, self.inputView.frame.size.height - XHInputView_StyleLarge_TBSpace - sendButtonHeight, sendButtonWidth, sendButtonHeight);
            _sendButton.backgroundColor = [UIColor blueColor];
            [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
            _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
            _sendButton.layer.cornerRadius = 1.5;
            [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_inputView addSubview:_sendButton];
            
            _textBgView = [[UIView alloc] initWithFrame:CGRectMake(XHInputView_StyleLarge_LRSpace, XHInputView_StyleLarge_TBSpace, XHInputView_ScreenW-2*XHInputView_StyleLarge_LRSpace, CGRectGetMinY(_sendButton.frame)-2*XHInputView_StyleLarge_TBSpace)];
            _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_inputView addSubview:_textBgView];
            
            _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _textBgView.bounds.size.width, _textBgView.bounds.size.height-XHInputView_CountLabHeight)];
            _textView.backgroundColor = [UIColor clearColor];
            _textView.font = [UIFont systemFontOfSize:15];
            _textView.delegate = self;
            [_textBgView addSubview:_textView];
            
            _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, 35)];
            _placeholderLab.font = _textView.font;
            _placeholderLab.text = @"请输入...";
            _placeholderLab.textColor = [UIColor lightGrayColor];
            [_textView addSubview:_placeholderLab];
            
            _countLab = [[UILabel alloc] initWithFrame:CGRectMake(0,_textView.bounds.size.height, _textBgView.bounds.size.width-5, XHInputView_CountLabHeight)];
            _countLab.font = [UIFont systemFontOfSize:14];
            _countLab.textColor =  [UIColor lightGrayColor];
            _countLab.textAlignment = NSTextAlignmentRight;
            _countLab.backgroundColor = _textView.backgroundColor;
            [_textBgView addSubview:_countLab];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == _textView && [keyPath isEqualToString:@"contentSize"]){
        CGFloat height = _textView.contentSize.height;
        CGFloat heightDefault = XHInputView_StyleDefault_Height;
        if(height >= heightDefault){
            [UIView animateWithDuration:0.3 animations:^{
                //调整frame
                CGRect frame = _showFrameDefault;
                frame.size.height = height;
                frame.origin.y = _showFrameDefault.origin.y - (height - _showFrameDefault.size.height);
                _inputView.frame = frame;
                //调整sendButton frame
                _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - _sendButton.frame.size.width, _inputView.bounds.size.height - _sendButton.bounds.size.height - XHInputView_StyleDefault_TBSpace, _sendButton.bounds.size.width, _sendButton.bounds.size.height);
                //调整textView frame
                _textView.frame = CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace, _textView.bounds.size.width, _inputView.bounds.size.height - 2*XHInputView_StyleDefault_TBSpace);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self resetFrameDefault];//恢复到,键盘弹出时,视图初始位置
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:_inputView]) {
        return NO;
    }
    return YES;
}
-(void)resetFrameDefault{
    self.inputView.frame = _showFrameDefault;
    self.sendButton.frame = _sendButtonFrameDefault;
    self.textView.frame =_textViewFrameDefault;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length){
        _placeholderLab.hidden = YES;
    }else{
        _placeholderLab.hidden = NO;
    }
    if(_maxCount>0){
        if(textView.text.length>=_maxCount){
            textView.text = [textView.text substringToIndex:_maxCount];
        }
        if(_style == InputViewStyleLarge){
            _countLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)_maxCount];
        }
    }
}

#pragma mark - Action
-(void)bgViewClick{
    [self hide];
}
-(void)sendButtonClick:(UIButton *)button{
    if(self.sendBlcok){
        BOOL hideKeyBoard = self.sendBlcok(self.textView.text);
        if(hideKeyBoard){
            [self hide];
        }
    }
}
#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)noti{
    if(_textView.isFirstResponder){
        NSDictionary *info = [noti userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGSize keyboardSize = [value CGRectValue].size;
        //NSLog(@"keyboardSize.height = %f",keyboardSize.height);
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = XHInputView_ScreenH - keyboardSize.height - frame.size.height;
            self.inputView.frame = frame;
            self.backgroundColor = XHInputView_BgViewColor;
            self.showFrameDefault = self.inputView.frame;
        }];
    }
}
- (void)keyboardWillDisappear:(NSNotification *)noti{
    
    if(_textView.isFirstResponder){
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.inputView.frame;
            frame.origin.y = XHInputView_ScreenH;
            self.inputView.frame = frame;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - set
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    if(_style == InputViewStyleLarge){
        _countLab.text = [NSString stringWithFormat:@"0/%ld",(long)maxCount];
    }
}
-(void)setTextViewBackgroundColor:(UIColor *)textViewBackgroundColor{
    _textViewBackgroundColor = textViewBackgroundColor;
    _textBgView.backgroundColor = textViewBackgroundColor;
}
-(void)setFont:(UIFont *)font{
    _font = font;
    _textView.font = font;
    _placeholderLab.font = _textView.font;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _placeholderLab.text = placeholder;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    _placeholderLab.textColor = placeholderColor;
    _countLab.textColor = placeholderColor;
}
-(void)setSendButtonBackgroundColor:(UIColor *)sendButtonBackgroundColor{
    _sendButtonBackgroundColor = sendButtonBackgroundColor;
    _sendButton.backgroundColor = sendButtonBackgroundColor;
}
-(void)setSendButtonTitle:(NSString *)sendButtonTitle{
    _sendButtonTitle = sendButtonTitle;
    [_sendButton setTitle:sendButtonTitle forState:UIControlStateNormal];
}
-(void)setSendButtonCornerRadius:(CGFloat)sendButtonCornerRadius{
    _sendButtonCornerRadius = sendButtonCornerRadius;
    _sendButton.layer.cornerRadius = sendButtonCornerRadius;
}
-(void)setSendButtonFont:(UIFont *)sendButtonFont{
    _sendButtonFont = sendButtonFont;
    _sendButton.titleLabel.font = sendButtonFont;
}

@end

