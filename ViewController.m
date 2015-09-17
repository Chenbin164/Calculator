//
//  ViewController.m
//  Calculator
//
//  Created by qianfeng on 15-1-11.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel  *label;
@property (nonatomic, strong) NSString *operator1;
@property (nonatomic, strong) NSString *operator2;
@property (nonatomic, strong) NSString *operand;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createCalculator];
}

- (void)createCalculator
{
    self.operand = self.operator1 = self.operator2 = @"";
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width-20, 60)];
    self.label.backgroundColor    = [UIColor grayColor];
    self.label.layer.cornerRadius = 5;
    self.label.numberOfLines      = 2;
    self.label.textAlignment      = NSTextAlignmentRight;
    [self.view addSubview:self.label];
    
    // 第一行按钮
    CGRect frame     = CGRectZero;
    NSArray *titles0 = @[@"MC", @"M+", @"M-", @"MR", @"清除"];
    CGFloat padding  = 10;
    CGFloat buttonWidth  = (self.view.bounds.size.width-(titles0.count+1)*padding)/titles0.count;
    CGFloat buttonHeight = 50;
    for (int i = 0; i < titles0.count; i++) {
        frame = CGRectMake(padding+i*(padding+buttonWidth), CGRectGetMaxY(self.label.frame)+padding, buttonWidth, buttonHeight);
        [self addButtonWithRect:frame title:titles0[i]];
    }
    
    // 其他按钮
    NSArray *titles1 = @[@"7", @"8", @"9", @"+",
                         @"4", @"5", @"6", @"-",
                         @"1", @"2", @"3", @"*",
                         @"0", @".", @"=", @"/"];
    buttonWidth = (self.view.bounds.size.width-5*padding)/4;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            [self addButtonWithRect:CGRectMake(padding+j*(padding+buttonWidth), CGRectGetMaxY(frame) + padding + i*(padding+buttonHeight), buttonWidth, buttonHeight) title:titles1[i*4+j]];
        }
    }
}

- (void)addButtonWithRect:(CGRect)rect title:(NSString *)title
{
    UIButton *button          = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame              = rect;
    button.backgroundColor    = [UIColor grayColor];
    button.layer.cornerRadius = 10;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button
{
    // 以M开头的按钮不处理
    if ([button.titleLabel.text hasPrefix:@"M"]) {
        return;
    }
    
    // 清除按钮被点击
    if ([button.titleLabel.text isEqualToString:@"清除"]) {
        self.operand    = @"";
        self.operator1  = @"";
        self.operator2  = @"";
        self.label.text = @"";
        return;
    }
    
    NSString *strInput = button.titleLabel.text;
    
    if ([self isOperand:strInput]) {  // 如果是运算符
        if (self.operand.length) { // 如果当前已经有一个操作符了，则对当前的两个操作数进行运算
            float result;
            float operator1 = [_operator1 floatValue];
            float operator2 = [_operator2 floatValue];
            if ([self.operand isEqualToString:@"+"]) {
                result = operator1 + operator2;
            } else if ([_operand isEqualToString:@"-"]) {
                result = operator1 - operator2;
            } else if ([_operand isEqualToString:@"*"]) {
                result = operator1 * operator2;
            } else if ([_operand isEqualToString:@"/"]) {
                result = operator1 / operator2;
            }
            
            self.operator1 = [NSString stringWithFormat:@"%0.2f", result];
            self.operator2 = @"";
            
            if ([strInput isEqualToString:@"="]) {
                self.operand = @"";
            } else {
                self.operand = strInput;
            }

            self.label.text = self.operator1;
        } else {
            self.operand = strInput;
        }
    } else { // 不是运算符，是操作数
        if (self.operand.length) { // 当前有操作符，这是第二操作数
            self.operator2 = [self.operator2 stringByAppendingString:strInput];
        } else {
            self.operator1 = [self.operator1 stringByAppendingString:strInput];
        }
    }
    
    if (_operator2.length) {
        _label.text = [NSString stringWithFormat:@"%@\n%@", _operator2, _operand];
    } else {
        _label.text = [NSString stringWithFormat:@"%@\n%@", _operator1, _operand];
    }
}

// 判断参数str是否为运算符
// 返回值为TRUE代表是运算符，FALSE代表不是运算符
- (BOOL)isOperand:(NSString *)str
{
    NSRange range = [str rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"+-*/="]];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end