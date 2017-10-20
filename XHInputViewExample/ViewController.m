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

@property (nonatomic, strong) XHInputView *inputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _inputView = [[XHInputView alloc] init];
    _inputView.maxCount = 30;
    _inputView.textViewBackgroundColor = [UIColor groupTableViewBackgroundColor];
    __weak typeof(self) weakSelf = self;
    _inputView.sendBlcok = ^(NSString *text) {
        
        NSLog(@"%@",weakSelf);
        NSLog(@"%@",text);
        
    };
    
    [self.view addSubview:_inputView];

}

- (IBAction)show:(UIButton *)sender {
    
    
    [_inputView show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
