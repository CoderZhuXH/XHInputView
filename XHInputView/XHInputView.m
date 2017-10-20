//
//  XHInputView.m
//  XHInputViewExample
//
//  Created by zhuxiaohui on 2017/10/20.
//  Copyright © 2017年 FORWARD. All rights reserved.
//

#import "XHInputView.h"

#define XHInputView_ScreenW    [UIScreen mainScreen].bounds.size.width
#define XHInputView_ScreenH    [UIScreen mainScreen].bounds.size.height
#define XHInputView_LRSpace 10
#define XHInputView_TBSpace 8
#define XHInputView_SendButtonSize  CGSizeMake(58, 29)
#define XHInputView_CountLabHeight 20
#define XHInputView_BgViewColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

static CGFloat keyboardAnimationDuration = 0.5;

@interface XHInputView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation XHInputView

-(void)show{
    
    [_textView becomeFirstResponder];
}
-(void)hide{
    
    [_textView resignFirstResponder];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, 170);
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    CGFloat sendButtonWidth = XHInputView_SendButtonSize.width;
    CGFloat sendButtonHeight = XHInputView_SendButtonSize.height;
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_LRSpace - sendButtonWidth, self.frame.size.height - XHInputView_TBSpace - sendButtonHeight, sendButtonWidth, sendButtonHeight);
    _sendButton.backgroundColor = [UIColor blueColor];
    [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sendButton.layer.cornerRadius = 1.5;
    [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];

    _textBgView = [[UIView alloc] initWithFrame:CGRectMake(XHInputView_LRSpace, XHInputView_TBSpace, XHInputView_ScreenW-2*XHInputView_LRSpace, CGRectGetMinY(_sendButton.frame)-2*XHInputView_TBSpace)];
    _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_textBgView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _textBgView.bounds.size.width, _textBgView.bounds.size.height-XHInputView_CountLabHeight)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.delegate = self;
    [_textBgView addSubview:_textView];
    
    _countLab = [[UILabel alloc] initWithFrame:CGRectMake(0,_textView.bounds.size.height, _textBgView.bounds.size.width-5, XHInputView_CountLabHeight)];
    _countLab.font = [UIFont systemFontOfSize:14];
    _countLab.textColor =  [UIColor lightGrayColor];
    _countLab.textAlignment = NSTextAlignmentRight;
    _countLab.backgroundColor = _textView.backgroundColor;
    [_textBgView addSubview:_countLab];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark -lazy
-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _bgView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewClick)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
#pragma mark - Action
-(void)bgViewClick{
    [self hide];
}
-(void)sendButtonClick:(UIButton *)button{
    
    if(self.sendBlcok) self.sendBlcok(self.textView.text);
}
#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)noti{
    
    if([_textView isFirstResponder]){
        NSDictionary *info = [noti userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGSize keyboardSize = [value CGRectValue].size;
        NSLog(@"keyboardSize.height = %f",keyboardSize.height);
        
        [self.superview addSubview:self.bgView];
        
        [self.superview bringSubviewToFront:self];

        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.frame;
            frame.origin.y = XHInputView_ScreenH - keyboardSize.height - frame.size.height;
            self.frame = frame;
            self.bgView.backgroundColor = XHInputView_BgViewColor;
        }];
    }
}

- (void)keyboardWillDisappear:(NSNotification *)noti{

    if([_textView isFirstResponder]){
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            CGRect frame = self.frame;
            frame.origin.y = XHInputView_ScreenH;
            self.frame = frame;
            self.bgView.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [_bgView removeFromSuperview];
            _bgView = nil;
        }];
    }
}

#pragma mark - set
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    _countLab.text = [NSString stringWithFormat:@"%ld",maxCount];
}
-(void)setTextViewBackgroundColor:(UIColor *)textViewBackgroundColor{
    _textViewBackgroundColor = textViewBackgroundColor;
    _textBgView.backgroundColor = textViewBackgroundColor;
}
-(void)setFont:(UIFont *)font{
    _font = font;
    _textView.font = font;
}
@end
