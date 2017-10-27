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

@interface XHInputView()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) InputViewStyle style;
@property (nonatomic, assign) CGRect showFrameDefault;
@property (nonatomic, assign) CGRect sendButtonFrameDefault;
@property (nonatomic, assign) CGRect textViewFrameDefault;
@end

@implementation XHInputView

-(void)show{
    
    if([self.delegate respondsToSelector:@selector(xhInputViewWillShow:)]){
        [self.delegate xhInputViewWillShow:self];
    }
    
    _textView.text = nil;
    _placeholderLab.hidden = NO;
    [_textView becomeFirstResponder];
    
    switch (_style) {
        case InputViewStyleLarge:{
            if(_maxCount>0) _countLab.text = [NSString stringWithFormat:@"0/%ld",(long)_maxCount];
        }
            break;
        case InputViewStyleDefault:{
            [self resetFrameDefault];
        }
            break;
        default:
            break;
    }
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
        self.backgroundColor = [UIColor whiteColor];
        switch (style) {
            case InputViewStyleDefault:{
                self.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, XHInputView_StyleDefault_Height);
                [self setupStyleDefaultUI];
            }
                break;
            case InputViewStyleLarge:{
                self.frame = CGRectMake(0, XHInputView_ScreenH, XHInputView_ScreenW, 170);
                [self setupStyleLargeUI];
            }
                break;
            default:
                break;
        }
        //键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - private
-(void)setupStyleDefaultUI{
    CGFloat sendButtonWidth = 45;
    CGFloat sendButtonHeight = self.bounds.size.height -2*XHInputView_StyleDefault_TBSpace;
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - sendButtonWidth, XHInputView_StyleDefault_TBSpace,sendButtonWidth, sendButtonHeight);
    [_sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_sendButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace, XHInputView_ScreenW - 3*XHInputView_StyleDefault_LRSpace - sendButtonWidth, self.bounds.size.height-2*XHInputView_StyleDefault_TBSpace)];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _textView.delegate = self;
    //_textView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:_textView];
    
    _placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, _textView.bounds.size.height)];
    _placeholderLab.font = _textView.font;
    _placeholderLab.text = @"请输入...";
    _placeholderLab.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_placeholderLab];
    
    _sendButtonFrameDefault = _sendButton.frame;
    _textViewFrameDefault = _textView.frame;
    
}

-(void)setupStyleLargeUI{
    
    CGFloat sendButtonWidth = 58;
    CGFloat sendButtonHeight = 29;
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleLarge_LRSpace - sendButtonWidth, self.frame.size.height - XHInputView_StyleLarge_TBSpace - sendButtonHeight, sendButtonWidth, sendButtonHeight);
    _sendButton.backgroundColor = [UIColor blueColor];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sendButton.layer.cornerRadius = 1.5;
    [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
    
    _textBgView = [[UIView alloc] initWithFrame:CGRectMake(XHInputView_StyleLarge_LRSpace, XHInputView_StyleLarge_TBSpace, XHInputView_ScreenW-2*XHInputView_StyleLarge_LRSpace, CGRectGetMinY(_sendButton.frame)-2*XHInputView_StyleLarge_TBSpace)];
    _textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_textBgView];
    
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
-(void)resetFrameDefault{
    self.frame = _showFrameDefault;
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
    if(_style == InputViewStyleDefault){
        
        CGFloat height = [self string:textView.text heightWithFont:textView.font constrainedToWidth:textView.bounds.size.width] + 2*XHInputView_StyleDefault_TBSpace;
        CGFloat heightDefault = XHInputView_StyleDefault_Height;
        if(height >= heightDefault){
            [UIView animateWithDuration:0.3 animations:^{
                //调整frame
                CGRect frame = _showFrameDefault;
                frame.size.height = height;
                frame.origin.y = _showFrameDefault.origin.y - (height - _showFrameDefault.size.height);
                self.frame = frame;
                
                //调整sendButton frame
                _sendButton.frame = CGRectMake(XHInputView_ScreenW - XHInputView_StyleDefault_LRSpace - _sendButton.frame.size.width, self.bounds.size.height - _sendButton.bounds.size.height - XHInputView_StyleDefault_TBSpace, _sendButton.bounds.size.width, _sendButton.bounds.size.height);
                
                //调整textView frame
                textView.frame = CGRectMake(XHInputView_StyleDefault_LRSpace, XHInputView_StyleDefault_TBSpace, textView.bounds.size.width, self.bounds.size.height - 2*XHInputView_StyleDefault_TBSpace);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self resetFrameDefault];
            }];
        }
        
    }
    
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
    
    if(_textView.isFirstResponder){
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
            self.showFrameDefault = self.frame;
        }];
    }
}

- (void)keyboardWillDisappear:(NSNotification *)noti{
    
    if(_textView.isFirstResponder){
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
    
    switch (_style) {
        case InputViewStyleLarge:{
            _countLab.text = [NSString stringWithFormat:@"0/%ld",(long)maxCount];
        }
            break;
            
        default:
            break;
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
#pragma mark - other
- (CGFloat)string:(NSString *)string heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize textSize;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:(NSStringDrawingUsesLineFragmentOrigin |
                                                 NSStringDrawingTruncatesLastVisibleLine)
                                     attributes:attributes
                                        context:nil].size;
    } else {
        textSize = [string sizeWithFont:textFont
                      constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin |
                                             NSStringDrawingTruncatesLastVisibleLine)
                                 attributes:attributes
                                    context:nil].size;
#endif
    
    return ceil(textSize.height);
    
}
@end
